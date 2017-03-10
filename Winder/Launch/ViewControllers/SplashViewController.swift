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
    @IBOutlet weak var pulseHeight: NSLayoutConstraint!
    @IBOutlet weak var pulseWidth: NSLayoutConstraint!
    @IBOutlet weak var pulse: Windicon!
    
    override func viewDidLoad() {
        pulse.configureWithColors(primaryColor: UIColor.red, secondaryColor: UIColor.blue, action: nil, pulses: 1)
        pulse.layer.cornerRadius = pulse.frame.size.width / 2.0
        pulse.pulse {
            FacebookController.shared.inflateUser(completion: { (successful) in
                    UIView.animate(withDuration: 0.5, animations: {
                        let centerPoint = self.pulse.center
                        let center = CGPoint(x: ((self.pulse.frame.size.width * 0.5) / 2.0) + 8.0, y: ((self.pulse.frame.size.height * 0.5) / 2.0) + 22.0)
                        let centerX = successful ? center.x - centerPoint.x : 0.0
                        let move = CGAffineTransform(translationX: centerX, y: center.y - centerPoint.y)
                        let scale = move.scaledBy(x: 0.5, y: 0.5)
                        self.pulse.transform = scale
                    }, completion: { (finished) in
                        let segueString = successful ? "loggedIn" : "notLoggedIn"
                        self.performSegue(withIdentifier: segueString, sender: nil)
                    })
            })
        }
    }
}
