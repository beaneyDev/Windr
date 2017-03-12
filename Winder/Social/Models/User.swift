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
    dynamic var fullName: String?
    dynamic var id: String?
    dynamic var imageLink: String?
    var ageRange: RealmOptional<Int> = RealmOptional<Int>()
    
    convenience init(fullName: String, id: String, imageLink: String, ageRange: Int) {
        self.init()
        self.fullName = fullName
        self.id = id
        self.imageLink = imageLink
        self.ageRange.value = ageRange
    }
}
