//
//  Notifiable.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation

protocol WNotifiable {
    func notify(eventType: EventType, userInfo: [String: Any]?)
}

enum EventType: String {
    case willEnterForeground = "WILL_ENTER_FOREGROUND"
    case terminated = "TERMINATED"
    case didEnterBackground = "WILL_ENTER_BACKGROUND"
    case custom = "CUSTOM"
}
