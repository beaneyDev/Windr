//
//  UserInfoBarView.swift
//  Winder
//
//  Created by Matt Beaney on 12/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class UserInfoBarView: UIView {
    var user: User?
    
    var infoLabels = [UILabel]()
    var animationIndex = 0
    
    func configure(completion: (() -> ())?) {
        guard let user = user else {
            return
        }
        
        var userInfo = [String]()
        
        if let rawAge = user.ageRange.value {
            let age = "Age:\n" + String(describing: rawAge) + " years + "
            userInfo.append(age)
        }
        
        //TODO: Implement gender and preference.
        let gender = "Gender:\n" + "Male"
        let interestedIn = "Interested in:\nWomen"
        
        var totalChars = 0
        
        for info in userInfo {
            totalChars += info.characters.count
        }
        
        var previousItem: UILabel?
        for (index, textItem) in userInfo.enumerated() {
            let item = UILabel()
            item.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight(rawValue: 0.1))
            item.alpha = 0.0
            item.numberOfLines = 0
            item.textAlignment = NSTextAlignment.center
            item.text = textItem
            item.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(item)
            
            //Top
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[item]|", options: [], metrics: nil, views: ["item": item]))
            
            //Decide if it should pin to container leading.
            if previousItem != nil {
                let leading = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: previousItem!, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                let width = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: previousItem!, attribute: .width, multiplier: 1.0, constant: 0.0)
                self.addConstraint(leading)
                self.addConstraint(width)
            } else {
                let leading = NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
                self.addConstraint(leading)
            }
            
            //If it's the last one.
            if index >= userInfo.count - 1 {
                let trailing = NSLayoutConstraint(item: item, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                self.addConstraint(trailing)
            }
            
            self.infoLabels.append(item)
            previousItem = item
        }
        
        animate(completion: completion)
    }
    
    func animate(completion: (() -> ())?) {
        if animationIndex >= infoLabels.count {
            completion?()
            return
        }
        
        let infoItem = infoLabels[animationIndex]
        
        UIView.animate(withDuration: 0.15, animations: {
            infoItem.alpha = 1.0
        }) { (finished) in
            self.animationIndex += 1
            self.animate(completion: completion)
        }
    }
}
