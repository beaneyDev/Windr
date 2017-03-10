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
    
    convenience init(fullName: String, id: String) {
        self.init()
        self.fullName = fullName
        self.id = id
    }
}
