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

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        
    }
    
    @IBAction func loginWithFB(_ sender: Any) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Process error")
            } else if (result?.isCancelled)! {
                print("Cancelled")
            } else {
                self.performSegue(withIdentifier: "chat", sender: nil)
            }
        }
    }
}
