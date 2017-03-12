//
//  FacebookController.swift
//  Winder
//
//  Created by Matt Beaney on 10/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookController {
    static var shared = FacebookController()
    typealias SocialCompleton = (_ success: Bool) -> ()
    
    func inflateUser(completion: @escaping SocialCompleton) {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, id, age_range"]).start(completionHandler: { (connection, result, error) in
                if let dict = result as? NSDictionary, let fullName = dict["name"] as? String, let id = dict["id"] as? String, let ageRange = dict["age_range"] as? NSDictionary, let ageMin = ageRange["min"] as? Int {
                    let imageURL = "https://graph.facebook.com/\(id)/picture?type=large"
                    let user: User = User(fullName: fullName, id: id, imageLink: imageURL, ageRange: ageMin)
                    RealmController.shared.store(object: user)
                    completion(true)
                } else {
                    completion(false)
                }
            })
        } else {
            completion(false)
        }
    }
}
