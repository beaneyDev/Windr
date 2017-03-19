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
    
    @IBOutlet weak var windicon: Windicon!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! //Used for keyboard hiding/showing.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton! {
        didSet {
            sendBtn.imageView?.contentMode = .scaleAspectFit
            sendBtn.imageView?.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    @IBOutlet weak var formField: UITextField!
    
    var messages = [SpeechBubbleMessage]()
    var resetAck: SocketAckEmitter?
    var socket: Socketable?
    var socketID: Int?
    
    override func viewDidLoad() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        self.navigationItem.hidesBackButton = true
        
        configureNibs()
        configureTableView()
        configureMessageBox()
        configureSocket()
        configureKeyboardHiding()
        //presentProfile()
    }
    
    func presentProfile() {
        let storyboard = UIStoryboard(name: "Social", bundle: nil)
        let profile = storyboard.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        
        let user = RealmController.shared.fetchCollection(type: User.self, primaryKey: SocialController.shared.fetchActiveSocialProvider() ?? "Facebook")
        
        if let user = user as? User {
            profile.user = user
        }

        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    //MARK: ACTION HANDLING
    @IBAction func didTapSend(_ sender: Any) {
        guard let formFieldText = self.formField.text, !formFieldText.isEmpty else { return }
        guard let socketID = self.socketID else {
            let alert = UIAlertController(title: "Issue connecting to server", message: "There was an issue connecting to the server, please try aain (Error 500).", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let message = Message(message: formFieldText)
        self.sendMessage(socketID: socketID, message: message)
        self.formField.text = ""
    }
    
    //MARK: KEYBOARD FUNCTIONS
    func configureKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: { 
            self.view.layoutIfNeeded()
        })
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
