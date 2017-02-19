//
//  WPulseView.swift
//  Winder
//
//  Created by Matt Beaney on 13/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

protocol Pulses: class {
    typealias PulseComplete = (() -> ())
    var pulseView: UIView! { get set }
    var pulseIterations: Int { get set }
    var pulseIndex: Int { get set }
    func pulse(completion: @escaping PulseComplete)
    func configure(iterations: Int)
}

extension Pulses where Self: UIView {
    func pulse(completion: @escaping PulseComplete) {
        if pulseIterations == pulseIndex {
            pulseIndex = 0
            completion()
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1.0
            self.backgroundColor = UIColor.red
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0.6
                self.backgroundColor = UIColor.orange
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.pulseIndex += 1
                self.pulse(completion: completion)
            })
        }
    }
    
    func configure(iterations: Int) {
        self.backgroundColor = UIColor.red
        self.pulseIterations = iterations
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.width / 2.0
    }
}

class WPulseView: UIView, Pulses {
    
    var pulseIterations: Int = 0
    var pulseIndex: Int = 0
    var pulseViewWidth: NSLayoutConstraint!
    var pulseViewHeight: NSLayoutConstraint!
    var pulseView: UIView!
}
