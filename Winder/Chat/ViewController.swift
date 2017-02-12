//
//  ViewController.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var formField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages: [(String, String)] = []
    var resetAck: SocketAckEmitter?
    var socket: SocketIOClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if (arch(i386) || arch(x86_64))
            socket = SocketIOClient(socketURL: NSURL(string:"http://localhost:8900")! as URL)
            addHandlers()
            socket!.connect()
        #else
            promptUserOnDevice()
        #endif
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func addHandlers() {
        socket?.on("message") {[weak self] data, ack in
            if let name = data[0] as? String, let message = data[1] as? String {
                self?.addMessage(name: name, message: message)
            }
        }
    }
    
    func addMessage(name: String, message: String) {
        self.messages.append((name, message))
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(item: self.messages.count - 1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }

    @IBAction func didTapSend(_ sender: Any) {
        let message = formField.text
        socket?.emit("message", message!)
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TestCell
        cell.titleLabel.text = self.messages[indexPath.row].1
        return cell
    }
}

class TestCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
}

