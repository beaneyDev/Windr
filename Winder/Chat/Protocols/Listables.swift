//
//  Listables.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit

//Protocol that brings together the various tableview rubbish.
protocol TableListable: UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView! { get set }
    func configureNibs()
    func configureTableView()
}

protocol CollectionListable: UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView: UITableView! { get set }
    func configureNibs()
    func configureCollectionView()
}
