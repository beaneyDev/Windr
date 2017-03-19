//
//  MenuItem.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation

class MenuItem: NSObject {
    var menuImage: String = ""
    var menuText: String = ""
    var menuAction: String = ""
    var userInfo: [AnyHashable: Any]?
    
    init(menuImage: String, menuText: String, menuAction: String, userInfo: [AnyHashable: Any]? = nil) {
        self.menuImage = menuImage
        self.menuText = menuText
        self.menuAction = menuAction
        self.userInfo = userInfo
    }
}
