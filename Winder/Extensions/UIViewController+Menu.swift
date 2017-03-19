//
//  UIViewController+Menu.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import MBUtils

extension UIViewController {
    func presentMenu(with items: [MenuItem], showClose: Bool, size: CGSize, delegate: MenuDelegate?) {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        presentBlocker()
        if let menuVC = storyboard.instantiateInitialViewController() as? BurgerMenuViewController {
            //Initial model setup
            menuVC.menuItems = items
            menuVC.delegate = delegate
            
            //Initial view setup
            menuVC.view.alpha = 0.0
            menuVC.view.layer.cornerRadius = 10.0
            menuVC.view.clipsToBounds = true
            menuVC.view.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            menuVC.view.layer.borderWidth = 0.5
            menuVC.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            menuVC.windiconHeight.constant = showClose ? 50.0 : 0.0
            
            //Insantiating view controller.
            menuVC.willMove(toParentViewController: self)
            self.addChildViewController(menuVC)
            self.view.addSubview(menuVC.view)
            
            self.sizeView(menuVC.view, size: size)
            self.centerView(menuVC.view)
            
            menuVC.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.4, animations: { 
                menuVC.view.alpha = 1.0
                menuVC.view.transform = CGAffineTransform.identity
            })
        }
    }
    
    func presentBlocker() {
        let blocker: UIView = UIView()
        blocker.translatesAutoresizingMaskIntoConstraints = false
        blocker.alpha = 0.0
        blocker.tag = 100000011
        blocker.backgroundColor = UIColor.black
        self.view.addSubview(blocker)
        sizeFullScreen(viewToSize: blocker)
        
        UIView.animate(withDuration: 0.2, animations: {
            blocker.alpha = 0.4
        })
    }
    
    func dismissView() {
        var blocker: UIView?
        
        if let superView = self.view.superview {
            for subview in superView.subviews {
                if subview.tag == 100000011 {
                    blocker = subview
                    break
                }
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            blocker?.alpha = 0.0
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (finished) in
            MBOn.main {
                blocker?.removeFromSuperview()
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
            }
        }
    }
}
