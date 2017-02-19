//
//  IntroViewController.swift
//  MB
//
//  Created by Matt Beaney on 15/01/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import UIKit
import MBUtils
import SocketIO
import RxCocoa
import RxSwift

class ChatViewController: UIViewController, ChatBox, SocketIO, WNotifiable {
    var disposeBag: DisposeBag!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! //Used for keyboard hiding/showing.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var formField: UITextField!
    
    var messages = [SpeechBubbleMessage]()
    var resetAck: SocketAckEmitter?
    var socket: Socketable?
    var socketID: Int? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        self.navigationItem.hidesBackButton = true
        
        configureNibs()
        configureTableView()
        configureMessageBox()
        configureSocket()
        configureKeyboardHiding()
    }
    
    //MARK: ACTION HANDLING
    @IBAction func didTapSend(_ sender: Any) {
        guard let formFieldText = self.formField.text, !formFieldText.isEmpty else { return }
        let message = Message(message: formFieldText)
        self.sendMessage(socketID: self.socketID!, message: message)
        self.formField.text = ""
    }
    
    //MARK: KEYBOARD FUNCTIONS
    func configureKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant += keyboardSize.height

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant -= keyboardSize.height
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
            })
        }
    }
}

//Unfortunately protocols do not currently allow for default implementations of delegates. So for now I'm doing it this way. 
extension ChatViewController: TableListable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: SpeechBubbleView = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SpeechBubbleView {
            cell.message = self.messages[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}
