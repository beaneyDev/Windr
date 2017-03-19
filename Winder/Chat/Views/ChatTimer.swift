//
//  MBTimer.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

typealias TimeableCompletion = () -> ()

protocol Timeable {
    var completion: TimeableCompletion? { get set }
    var timer: Timer? { get set }
    var ticks: Int? { get set }
    func tick()
}

class ChatTimer: UIView, Timeable {
    var timerLabel: UILabel?
    var timer: Timer?
    var ticks: Int?
    var completion: TimeableCompletion?
    
    func configure(with time: Int, completion: @escaping TimeableCompletion) {
        timerLabel = UILabel()
        guard let timerLabel = timerLabel else { return }
        
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerLabel)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: ["label": timerLabel])
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": timerLabel])
        self.addConstraints(horizontal)
        self.addConstraints(vertical)
        
        timerLabel.text = labelFor(seconds: time)
        self.ticks = time
        self.completion = completion
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ChatTimer.tick), userInfo: nil, repeats: true)
    }
    
    func tick() {
        guard let ticks = self.ticks else { return }
        self.ticks = ticks - 1
        
        guard ticks >= 0 else {
            self.timer?.invalidate()
            self.timer = nil
            self.completion?()
            return
        }
        
        let timerString = labelFor(seconds: ticks)
        if let timerLabel = self.timerLabel {
            if ticks == 10 {
                UIView.animate(withDuration: 0.1, animations: {
                    timerLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                    timerLabel.text = timerString
                }, completion: { (finished) in
                    UIView.animate(withDuration: 0.1, animations: {
                        timerLabel.transform = CGAffineTransform.identity
                    })
                })
            } else {
                timerLabel.text = timerString
            }
            
            if ticks <= 10 {
                timerLabel.textColor = UIColor.red
            } else {
                timerLabel.textColor = UIColor.black
            }
        }
    }
    
    private func labelFor(seconds: Int) -> String {
        let minutesSeconds = secondsToMinutesSeconds(seconds: seconds)
        let minutes = String(minutesSeconds.0).characters.count > 1 ? "\(minutesSeconds.0)" : "0\(minutesSeconds.0)"
        let seconds = String(minutesSeconds.1).characters.count > 1 ? "\(minutesSeconds.1)" : "0\(minutesSeconds.1)"
        let timerString = "\(minutes):\(seconds)"
        return timerString
    }
    
    private func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
