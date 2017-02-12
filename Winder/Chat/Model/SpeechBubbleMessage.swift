//
//  SpeechBubbleMessage.swift
//  MB
//
//  Created by Matt Beaney on 15/01/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation

enum BubblePosition: String {
    case left
    case right
}

class Message: NSObject {
    var message: String?
    init(message: String) {
        self.message = message
    }
}

class SpeechBubbleMessage: Message {
    var position: BubblePosition?
    
    init(message: String, position: BubblePosition) {
        super.init(message: message)
        self.position = position
    }
}
