//
//  WNotificationCenter.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation

class WNotificationCenter {
    static var shared = WNotificationCenter()
    var observers: [String: [WNotifiable]] = [:]
    
    func notify(eventType: EventType, userInfo: [String: Any]?) {
        for observer in observers[eventType.rawValue] ?? [] {
            observer.notify(eventType: eventType, userInfo: userInfo)
        }
    }
    
    func subscribe(eventType: EventType, notifiable: WNotifiable) {
        if observers[eventType.rawValue] != nil {
            observers[eventType.rawValue]!.append(notifiable)
        } else {
            let notifiables = [notifiable]
            observers[eventType.rawValue] = notifiables
        }
    }
}
