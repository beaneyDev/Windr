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
    @IBOutlet weak var leftTick: UIImageView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var loadingLblHeight: NSLayoutConstraint!
    
    var message: SpeechBubbleMessage? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        self.backgroundColor = UIColor.clear
        self.leftTick.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        bg.layer.cornerRadius = 7.0
        self.clipsToBounds = true
        self.loadingLbl.alpha = 1.0
        configureState()
    }
    
    func configureState() {
        guard let message = message else {
            return
        }
        
        messageLabel.text = message.message
        let showLeft = message.position == .left
        leftTick.alpha = showLeft ? 1.0 : 0.0
    }
}
