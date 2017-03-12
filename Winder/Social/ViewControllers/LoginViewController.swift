//
//  LoginViewController.swift
//  Winder
//
//  Created by Matt Beaney on 19/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MBUtils

class LoginViewController: UIViewController {
    
    @IBOutlet weak var windiconWidth: NSLayoutConstraint!
    @IBOutlet weak var windicon: Windicon!
    
    override func viewDidLoad() {
        configureWindicon()
    }
    
    func configureWindicon() {
        self.windicon.configureWithColors(primaryColor: #colorLiteral(red: 0.1764705882, green: 0.4980392157, blue: 0.7568627451, alpha: 1), secondaryColor: nil, action: {
            print("HI")
        }, pulses: nil)
        
        self.windicon.layer.cornerRadius = self.windicon.frame.size.width / 2.0
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = 0.3
        animation.fromValue = self.windicon.layer.cornerRadius
        animation.toValue = 0.0
        self.windicon.layer.add(animation, forKey: "cornerRadius")
        self.windicon.layer.cornerRadius = 0.0
        
        //Setting width on a delay so as not to conflict with the above animation.
        MBOn.delay(0.1) {
            MBOn.main {
                self.windiconWidth.constant = self.view.frame.size.width - 32.0
                UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    self.windicon.configureWithImage(primaryImage: UIImage(named: "header-logo")!, secondaryImage: nil, action: nil, pulses: 1)
                    self.windicon.pulse { }
                })
            }
        }
    }
    
    @IBAction func loginWithWindr(_ sender: Any) {
        self.performSegue(withIdentifier: "chat", sender: nil)
    }
    
    @IBAction func loginWithFB(_ sender: Any) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            FacebookController.shared.inflateUser(completion: { (success) in
                if success {
                    self.performSegue(withIdentifier: "chat", sender: nil)
                } else {
                    UIAlertView(title: "Something went wrong...", message: "There was an error authenticating with Facebook, please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            })
        }
    }
}
