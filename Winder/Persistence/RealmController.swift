//
//  RealmManager.swift
//  Winder
//
//  Created by Matt Beaney on 10/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import RealmSwift

class RealmController {
    static var shared = RealmController()
    func store(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    func fetchCollection(thingy: Object.Type) -> Results<Object> {
        let realm = try! Realm()
        return realm.objects(thingy.self)
    }
    
    func fetch() -> Object? {
        return nil
    }
}
