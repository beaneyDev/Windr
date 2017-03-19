//
//  FacebookController.swift
//  Winder
//
//  Created by Matt Beaney on 10/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TwitterKit
import Fabric

typealias SocialCompleton = (_ success: Bool) -> ()

protocol Social {
    func inflateUser(userInfo: [AnyHashable: Any]?, completion: @escaping SocialCompleton)
    var socialName: String { get set }
}

class SocialController {
    static var shared = SocialController()
    private var socialKey = "SOCIAL_PROVIDER"
    
    func storeActiveSocialProvider(socialProvider: String) {
        UserDefaults.standard.set(socialProvider, forKey: socialKey)
    }
    
    func fetchActiveSocialProvider() -> String? {
        return UserDefaults.standard.object(forKey: socialKey) as? String
    }
}

class FacebookController: Social {
    static var shared = FacebookController()
    var socialName: String = "Facebook"
    
    func inflateUser(userInfo: [AnyHashable: Any]? = nil, completion: @escaping SocialCompleton) {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, id, age_range"]).start(completionHandler: { (connection, result, error) in
                if let dict = result as? NSDictionary, let fullName = dict["name"] as? String, let id = dict["id"] as? String, let ageRange = dict["age_range"] as? NSDictionary, let ageMin = ageRange["min"] as? Int {
                    let imageURL = "https://graph.facebook.com/\(id)/picture?type=large"
                    let user: User = User(fullName: fullName, id: id, imageLink: imageURL, ageRange: ageMin, socialProvider: self.socialName)
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

class TwitterController: Social {
    static var shared = TwitterController()
    var socialName: String = "Twitter"

    func inflateUser(userInfo: [AnyHashable : Any]?, completion: @escaping SocialCompleton) {
        guard let session = userInfo?["session"] as? TWTRSession else {
            completion(false)
            return
        }

        let client = TWTRAPIClient()
        client.loadUser(withID: session.userID) { (user, error) -> Void in
            if let user = user {
                let user: User = User(fullName: user.screenName, id: user.userID, imageLink: user.profileImageURL, ageRange: nil, socialProvider: self.socialName)
                RealmController.shared.store(object: user)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
