//
//  User.swift
//  Winder
//
//  Created by Matt Beaney on 19/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var socialProvider: String?
    @objc dynamic var fullName: String?
    @objc dynamic var id: String?
    @objc dynamic var imageLink: String?
    var ageRange: RealmOptional<Int> = RealmOptional<Int>()
    
    convenience init(fullName: String, id: String, imageLink: String, ageRange: Int?, socialProvider: String) {
        self.init()
        self.socialProvider = socialProvider
        self.fullName = fullName
        self.id = id
        self.imageLink = imageLink
        self.ageRange.value = ageRange
    }
    
    override class func primaryKey() -> String {
        return "socialProvider"
    }
}
