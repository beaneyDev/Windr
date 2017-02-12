//
//  SocketIO.swift
//  Winder
//
//  Created by Matt Beaney on 12/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import Foundation
import SocketIO

protocol SocketIO: class {
    var resetAck: SocketAckEmitter? { get set }
    var socket: SocketIOClient? { get set }
    var socketID: Int? { get set }
    func configureSocket()
    func configureTerminationObserver()
    func addHandlers()
}

extension SocketIO {
    func configureSocket() {
        #if (arch(i386) || arch(x86_64))
            self.socket = SocketIOClient(socketURL: NSURL(string:"http://localhost:8900")! as URL)
            addHandlers()
            socket!.connect()
        #else
            self.socket = SocketIOClient(socketURL: NSURL(string:"http://192.168.0.62:8900")! as URL)
            addHandlers()
            socket!.connect()
        #endif
        
        configureTerminationObserver()
    }
}

extension SocketIO where Self : WNotifiable {
    func configureTerminationObserver() {
        WNotificationCenter.shared.subscribe(eventType: EventType.didEnterBackground, notifiable: self)
    }
    
    func notify(eventType: EventType, userInfo: [String: Any]?) {
        //Do termination code here.
        print("disconnecting")
        self.socket?.disconnect()
    }
}

extension SocketIO where Self : ChatBox {
    func addHandlers() {
        socket?.on("message") {[weak self] data, ack in
            guard let name = data[0] as? String, let message = data[1] as? String else { return }
            self?.addIncomingMessage(name: name, message: message, socketID: 0)
        }
    }
    
    func addIncomingMessage(name: String, message: String, socketID: Int) {
        //guard let mySocketID = self.socketID else { return }
        //TODO: Implement socket ID checking to determine position of the message.
        let message = SpeechBubbleMessage(message: message, position: BubblePosition.left)
        self.messages.append(message)
        self.updateUIWithMessage(message: message)
    }
    
    func sendMessage(message: Message) {
        socket?.emit("sendMsg", self.socketID ?? 0, message.message ?? "Message failed to send")
    }
    
    func userTyping(isTyping: Bool) {
        socket?.emit("userTyping", self.socketID ?? 0, isTyping)
    }
}
