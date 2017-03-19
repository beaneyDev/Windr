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
    var pulseIterations: Int? { get set }
    var pulseIndex: Int { get set }
    var stopPulsing: Bool { get set }
    
    func pulse(completion: @escaping PulseComplete)
    func pulseOut()
    func pulseIn()
    func configure(iterations: Int?)
}

extension Pulses where Self: UIView {
    func pulseIndefinitely(completion: @escaping PulseComplete) {
        guard !stopPulsing else {
            completion()
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.pulseOut()
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                self.pulseIn()
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.pulseIndefinitely(completion: completion)
            })
        }
    }
    
    func pulse(completion: @escaping PulseComplete) {
        guard let pulseIterations = self.pulseIterations, pulseIterations > pulseIndex else {
            pulseIndex = 0
            completion()
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.pulseOut()
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                self.pulseIn()
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.pulseIndex += 1
                self.pulse(completion: completion)
            })
        }
    }
}
