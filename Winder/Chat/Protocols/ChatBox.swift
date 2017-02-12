//
//  ChatBox.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import MBUtils
import RxSwift
import RxCocoa

protocol ChatBox: class  {
    func configureMessageBox()
    func sendMessage(socketID: Int, message: Message)
    func updateUIWithMessage(message: Message)
    
    var disposeBag: DisposeBag! { get set }
    var messages: [SpeechBubbleMessage] { get set }
    var sendBtn: UIButton! { get set }
    var formField: UITextField! { get set }
}

extension ChatBox {
    func configureMessageBox() {
        self.sendBtn.contentMode = UIViewContentMode.scaleAspectFit
    }
}

extension ChatBox where Self : TableListable {
    func configureTableView() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140.0
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }
    
    func configureNibs() {
        let messageNib = UINib(nibName: "SpeechBubbleView", bundle: nil)
        self.tableView.register(messageNib, forCellReuseIdentifier: "cell")
    }
    
    func updateUIWithMessage(message: Message) {
        MBOn.main {
            self.tableView.beginUpdates()
            let indexpath = IndexPath(item: self.messages.count - 1, section: 0)
            self.tableView.insertRows(at: [indexpath], with: .automatic)
            self.tableView.endUpdates()
            MBOn.delay(0.3, task: { 
                self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.bottom, animated: false)
            })
        }
    }
}

extension ChatBox where Self: SocketIO {
    var disposeBag: DisposeBag {
        return DisposeBag()
    }
    
    func configureTypingStream() {
        self.formField
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                
            })
            .addDisposableTo(disposeBag)
    }
}
