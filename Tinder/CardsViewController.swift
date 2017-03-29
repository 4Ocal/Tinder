//
//  ViewController.swift
//  Tinder
//
//  Created by Calvin Chu on 3/29/17.
//  Copyright © 2017 Calvin Chu. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var cardView: UIImageView!
    var cardInitialCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        //let cardView = sender.view as! UIImageView
        let viewWidth = view.frame.width
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let location = sender.location(in: cardView)
        let touchStart = Date()
        var direction: Double = 1
        if (velocity.x < 0 && location.y > cardView.frame.midY) || (velocity.x > 0 && location.y < cardView.frame.midY) {
            direction = -1
        }
        
        if sender.state == .began {
            cardInitialCenter = CGPoint(x: cardView.frame.midX, y: cardView.frame.midY)
        } else if sender.state == .changed {
            let touchEnd = Date()
            let timeDelta: Double = touchEnd.timeIntervalSince(touchStart)
            let rotation = (0.1 / timeDelta < 0.99) ? 0.1 / timeDelta : 0.99
            
            cardView.transform = cardView.transform.translatedBy(x: translation.x, y: 0)
            cardView.transform = cardView.transform.rotated(by: CGFloat(direction * rotation * Double.pi / 180))
        } else if sender.state == .ended {
            if velocity.x > 50 {
             UIView.animate(withDuration: 0, delay: 0, animations: {
                self.cardView.transform = self.cardView.transform.translatedBy(x: viewWidth, y: 0)
             }, completion: nil)
             
            } else if velocity.x < -50 {
             UIView.animate(withDuration: 0, delay: 0, animations: {
                self.cardView.transform = self.cardView.transform.translatedBy(x: -1 * viewWidth, y: 0)
             }, completion: nil)
            } else {
                cardView.transform = CGAffineTransform.identity
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.image = cardView.image
    }

}

