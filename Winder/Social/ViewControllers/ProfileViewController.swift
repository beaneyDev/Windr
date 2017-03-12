//
//  ProfileViewController.swift
//  Winder
//
//  Created by Matt Beaney on 12/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import MBCache
import MBUtils

class ProfileViewController : UIViewController {
    @IBOutlet weak var windicon: Windicon! {
        didSet {
            self.windicon.backgroundColor = UIColor.clear
            self.windicon.layer.cornerRadius = self.windicon.frame.size.width / 2.0
            self.windicon.clipsToBounds = true
            
            self.windicon.configureWithColors(primaryColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), secondaryColor: nil, action: {
                print("HI")
            }, pulses: 0)
        }
    }
    var url: String = ""
    var user: User?
    @IBOutlet weak var profileImg: MBImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var userInfo: UserInfoBarView!
    @IBOutlet weak var separatorWidth: NSLayoutConstraint!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var twitter: UIButton!
    
    override func viewDidLoad() {
        self.profileName.alpha = 0.0
        self.profileImg.backgroundColor = UIColor.clear
        self.userInfo.backgroundColor = UIColor.clear
        self.facebook.alpha = 0.0
        self.twitter.alpha = 0.0
        
        
        
        if let user = self.user {
            self.configureImage(user: user, completion: {
                self.configureLabels(user: user, completion: {
                    self.expandSeparator {
                        self.userInfo.user = user
                        self.userInfo.configure(completion: {
                            self.facebook.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            UIView.animate(withDuration: 0.2, animations: {
                                self.facebook.transform = CGAffineTransform.identity
                                self.facebook.alpha = 1.0
                            }, completion: { (finished) in
                                self.twitter.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                UIView.animate(withDuration: 0.2, animations: {
                                    self.twitter.transform = CGAffineTransform.identity
                                    self.twitter.alpha = 1.0
                                })
                            })
                        })
                    }
                })
            })
        }
    }
    
    func configureImage(user: User, completion: @escaping ImageCompletion) {
        guard let image = user.imageLink else {
            completion()
            return
        }
        
        MBOn.delay(0.1, task: {
            self.profileImg.layer.borderColor = UIColor.lightGray.cgColor
            self.profileImg.layer.borderWidth = 1.0
            self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2.0
            self.profileImg.configureWithURL(url: image, with: .pop, defaultImage: nil, completion: {
                completion()
            })
            
            self.profileImg.MBContentMode = UIViewContentMode.scaleAspectFill
        })
    }
    
    func configureLabels(user: User, completion: @escaping () -> ()) {
        guard let fullName = user.fullName else { return }
        self.profileName.text = fullName
        self.profileName.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.profileName.alpha = 1.0
            self.profileName.transform = CGAffineTransform.identity
        }) { (finished) in
            completion()
        }
    }
    
    func expandSeparator(completion: @escaping () -> ()) {
        self.separatorWidth.constant = self.view.frame.size.width
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            completion()
        }
    }
}
