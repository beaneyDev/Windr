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
    var stopPulsing: Bool = false
    
    //Optional 
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    var primaryImage: UIImage?
    var secondaryImage: UIImage?
    var imageView: UIImageView?
    var spinner: UIActivityIndicatorView?
    
    //Windicon stuff.
    var windiAction: WindiconAction?
    
    //Action handling
    func tapped() {
        self.windiAction?()
    }
    
    //MARK: RESET FUNCTIONS
    func hardReset() {
        self.resetImage()
        self.resetColors()
        self.resetSpinner()
    }
    
    func resetImage() {
        self.primaryImage = nil
        self.secondaryImage = nil
        self.imageView?.image = nil
    }
    
    func resetColors() {
        self.primaryColor = nil
        self.secondaryColor = nil
    }
    
    func resetSpinner() {
        self.spinner?.removeFromSuperview()
        self.spinner = nil
    }
    
    //MARK: INITIAL CONFIGURATIONS
    private func configureGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(Windicon.tapped))
        self.addGestureRecognizer(gesture)
    }
    
    func configurePulses(pulses: Int?) {
        configure(iterations: pulses)
    }
    
    //MARK: CUSTOMISABLE CONFIGURATIONS
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
    
    func configureWithSpinner() {
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.spinner?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.spinner!)
        let centerX = NSLayoutConstraint(item: self.spinner!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: self.spinner!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([centerX, centerY])
        self.spinner?.startAnimating()        
    }
    
    //MARK: COOL UI FUNCTIONS
    func roundMe(cornerRadius: CGFloat) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.duration = 0.3
        animation.fromValue = self.layer.cornerRadius
        animation.toValue = cornerRadius
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = cornerRadius
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
