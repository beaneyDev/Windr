//
//  MenuItemView.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class MenuItemView: UICollectionViewCell {
    @IBOutlet weak var menuItemImage: UIImageView!
    @IBOutlet weak var menuItemText: UILabel!
    @IBOutlet weak var container: UIView!
    
    func configure(menuItem: MenuItem) {
        self.menuItemImage.image = UIImage(named: menuItem.menuImage)
        self.menuItemText.text = menuItem.menuText
        
        //Optional background color.
        if let userInfo = menuItem.userInfo, let color = userInfo["backgroundColor"] as? UIColor, let container = self.container {
            container.backgroundColor = color
        }
    }
}
