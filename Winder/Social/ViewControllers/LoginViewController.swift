//
//  LoginViewController.swift
//  Winder
//
//  Created by Matt Beaney on 19/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import MBUtils

import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import Fabric

class LoginViewController: UIViewController {
    
    @IBOutlet weak var windiconWidth: NSLayoutConstraint!
    @IBOutlet weak var windicon: Windicon!
    
    override func viewDidLoad() {
        configureWindicon()
    }
    
    //MARK: UI FUNCTIONS.
    func load(completion: @escaping () -> ()) {
        self.windiconWidth.constant = 50.0
        self.windicon.resetImage()
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            completion()
        }
    }
    
    func configureWindicon() {
        self.windicon.configureWithColors(primaryColor: #colorLiteral(red: 0.1764705882, green: 0.4980392157, blue: 0.7568627451, alpha: 1), secondaryColor: nil, action: {
            print("HI")
        }, pulses: nil)
        
        self.windicon.layer.cornerRadius = self.windicon.frame.size.width / 2.0
        self.windicon.roundMe(cornerRadius: 0.0)
        
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
    
    //MARK: LOGIN FUNCTIONS.
    @IBAction func loginWithTwitter(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn { session, error in
            if let session = session {
                self.loadUser(userInfo: ["session": session], socialProvider: TwitterController.shared)
            } else {
            }
        }
    }
    
    @IBAction func loginWithFB(_ sender: Any) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            self.loadUser(socialProvider: FacebookController.shared)
        }
    }
    
    func loadUser(userInfo: [AnyHashable: Any]? = nil, socialProvider: Social) {
        self.load {
            MBOn.delay(0.1, task: {
                self.windicon.roundMe(cornerRadius: self.windicon.frame.size.width / 2.0)
                self.windicon.configureWithSpinner()
                socialProvider.inflateUser(userInfo: userInfo, completion: { (success) in
                    if success {
                        SocialController.shared.storeActiveSocialProvider(socialProvider: socialProvider.socialName)
                        self.performSegue(withIdentifier: "chat", sender: nil)
                    } else {
                        self.alertIssueWithSocialProvider(provider: socialProvider.socialName)
                    }
                })
            })
        }
    }
    
    //MARK: ERROR HANDLING.
    func alertIssueWithSocialProvider(provider: String) {
        let alert = UIAlertController(title: "Something went wrong...", message: "There was an error authenticating with \(provider), please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        MBOn.main {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
