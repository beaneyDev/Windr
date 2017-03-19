//
//  MenuViewController.swift
//  Winder
//
//  Created by Matt Beaney on 19/03/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

class BurgerMenuViewController: MenuViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var windicon: Windicon! {
        didSet {
            windicon.configureWithImage(primaryImage: #imageLiteral(resourceName: "close"), secondaryImage: nil, pulses: 0) { 
                self.dismissView()
            }
        }
    }
    @IBOutlet weak var windiconHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        let menuNib = UINib(nibName: "MenuItemView", bundle: nil)
        self.collectionView.register(menuNib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}
