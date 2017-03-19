//
//  UIViewController+AutoLayout.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func centerView(_ viewToAdd: UIView) {
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: viewToAdd, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: viewToAdd, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([centerX, centerY])
    }
    
    func sizeView(_ viewToAdd: UIView, size: CGSize) {
        viewToAdd.translatesAutoresizingMaskIntoConstraints = false
        let width = NSLayoutConstraint(item: viewToAdd, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: size.width)
        let height = NSLayoutConstraint(item: viewToAdd, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: size.height)
        self.view.addConstraints([width, height])
    }
    
    func sizeFullScreen(viewToSize: UIView) {
        let width = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": viewToSize])
        let height = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": viewToSize])
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: width)
        constraints.append(contentsOf: height)
        self.view.addConstraints(constraints)
    }
}
