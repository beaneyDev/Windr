//
//  HomeMenuViewController.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class HomeMenuViewController: MenuViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        populate()
        configureCollectionView()
    }
    
    func populate() {
        let menuItem1 = MenuItem(menuImage: "settings-icon", menuText: "Settings", menuAction: "settings", userInfo: ["backgroundColor": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        let menuItem2 = MenuItem(menuImage: "chat-icon", menuText: "Start chatting", menuAction: "chat", userInfo: ["backgroundColor": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)])
        self.menuItems = [menuItem1, menuItem2]
    }
    
    func configureCollectionView() {
        let menuNib = UINib(nibName: "HomeMenuItemView", bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func didTapMenuItem(menuItem: MenuItem) {
        switch menuItem.menuAction {
            case "chat":
            self.performSegue(withIdentifier: "chat", sender: nil)
            break
        default:
            break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 75.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didTapMenuItem(menuItem: menuItems[indexPath.row])
    }
}
