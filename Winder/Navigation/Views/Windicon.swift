//
//  Windicon.swift
//  Winder
//
//  Created by Matt Beaney on 10/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

typealias WindiconAction = () -> ()

class Windicon: UIView {
    //Pulsable conformance.
    var pulseIterations: Int?
    var pulseIndex: Int = 0
    var pulseViewWidth: NSLayoutConstraint!
    var pulseViewHeight: NSLayoutConstraint!
    var pulseView: UIView!
    
    //Optional 
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    var primaryImage: UIImage?
    var secondaryImage: UIImage?
    var imageView: UIImageView?
    
    //Windicon stuff.
    var windiAction: WindiconAction?
    
    //Action handling
    func tapped() {
        self.windiAction?()
    }
    
    //Basic setup
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(Windicon.tapped))
        self.addGestureRecognizer(gesture)
    }
    
    func configurePulses(pulses: Int?) {
        configure(iterations: pulses)
    }
    
    func configureWithImage(primaryImage: UIImage, secondaryImage: UIImage?, action: WindiconAction?, pulses: Int?) {
        configureGesture()
        self.windiAction = action
        self.primaryImage = primaryImage
        self.secondaryImage = secondaryImage
        self.imageView = UIImageView(image: primaryImage)
        self.imageView!.alpha = 0.0
        self.imageView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView!)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[image]|", options: [], metrics: nil, views: ["image": self.imageView!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[image]|", options: [], metrics: nil, views: ["image": self.imageView!]))
        
        UIView.animate(withDuration: 0.2) { 
            self.imageView?.alpha = 1.0
        }
        
        configurePulses(pulses: pulses)
    }
    
    func configureWithColors(primaryColor: UIColor, secondaryColor: UIColor?, action: WindiconAction?, pulses: Int?) {
        configureGesture()
        self.windiAction = action
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundColor = self.primaryColor
        configurePulses(pulses: pulses)
    }
}

extension Windicon: Pulses {
    //Pulsable stuff
    func pulseIn() {
        self.imageView?.image = self.primaryImage
        self.backgroundColor = self.primaryColor
    }
    
    func pulseOut() {
        self.imageView?.image = self.secondaryImage
        self.backgroundColor = self.secondaryColor
    }
    
    func configure(iterations: Int?) {
        self.pulseIterations = iterations
        self.layoutIfNeeded()
    }
}
