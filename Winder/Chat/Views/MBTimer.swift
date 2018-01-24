//
//  MBTimer.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

protocol Timeable {
    var timer: Timer! { get set }
    var ticks: Int! { get set }
    func tick()
}

class MBTimer: UIView, Timeable {
    var timerLabel: UILabel!
    var timer: Timer!
    var ticks: Int!
    
    func configure(with time: Int) {
        timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerLabel)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label": timerLabel])
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": timerLabel])
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
        
        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(MBTimer.tick), userInfo: nil, repeats: true)
        self.ticks = time
    }
    
    @objc func tick() {
        
    }
//    
//    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
//        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
//    }
}
