//
//  SpeechBubbleView.swift
//  MB
//
//  Created by Matt Beaney on 15/01/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class SpeechBubbleView: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bg: UIView!
    @IBOutlet var rightPin: NSLayoutConstraint!
    @IBOutlet var leftPin: NSLayoutConstraint!
    
    var message: SpeechBubbleMessage? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        self.backgroundColor = UIColor.clear
        bg.layer.cornerRadius = 7.0
        self.clipsToBounds = true
        configureState()
    }
    
    func configureState() {
        guard let message = message else {
            return
        }
        
        messageLabel.text = message.message
        let showLeft = message.position == .left
        
        if showLeft {
            rightPin.isActive = false
            leftPin.isActive = true
        } else {
            rightPin.isActive = true
            leftPin.isActive = false
        }
    }
}
