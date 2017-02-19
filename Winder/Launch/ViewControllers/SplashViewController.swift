//
//  SplashViewController.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class SplashViewController: UIViewController {
    
    
    @IBOutlet weak var pulse: WPulseView!
    @IBOutlet weak var pulseHeight: NSLayoutConstraint!
    @IBOutlet weak var pulseWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        pulse.configure(iterations: 2)
        pulse.pulse {            
            UIView.animate(withDuration: 0.5, animations: { 
                let centerPoint = self.pulse.center
                let center = CGPoint(x: self.pulse.frame.size.width / 2.0 + 5.0, y: self.pulse.frame.size.height / 2.0 + 5.0)
                let move = CGAffineTransform(translationX: center.x - centerPoint.x, y: center.y - centerPoint.y)
                let scale = move.scaledBy(x: 0.5, y: 0.5)
                self.pulse.transform = scale
            }, completion: { (finished) in
                if FBSDKAccessToken.current() != nil {
                    self.performSegue(withIdentifier: "loggedIn", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "loggedIn", sender: nil)
                }
            })
        }
    }
}
