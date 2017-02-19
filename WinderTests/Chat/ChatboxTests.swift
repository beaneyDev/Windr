//
//  ChatboxTests.swift
//  Winder
//
//  Created by Matt Beaney on 19/02/2017.
//  Copyright © 2017 Matt Beaney. All rights reserved.
//

import XCTest
import SocketIO
import UIKit
import RxCocoa
import RxSwift

@testable import Winder

class ChatboxTests: XCTestCase {
    
    var mockChatBox: MockChatBox!
    
    override func setUp() {
        mockChatBox = MockChatBox()
        mockChatBox.socket = MockSocket()
        mockChatBox.socketID = 0
        super.setUp()
    }
    
    override func tearDown() {
        self.mockChatBox = nil
        super.tearDown()
    }
    
    //IT SHOULD ONLY HANDLE TWO EVENTS CURRENTLY.
    func testHandlers() {
        mockChatBox.addHandlers()
        let mockSocket = mockChatBox.socket as! MockSocket
        XCTAssert(mockSocket.handlers.keys.count == 2)
    }
    
    //IT SHOULD EMIT A MESSAGE WHEN SENDMESSAGE IS CALLED
    func testSend() {
        let testMessage: Message = Message(message: "TEST_MESSAGE")
        let messageExpectation = expectation(description: "Check emit fired")
        
        let mockSocket = mockChatBox.socket as! MockSocket
        
        mockSocket.testCompletion = { eventName, socketID, message in
            XCTAssert(eventName == "sendMsg")
            XCTAssert(socketID == 0)
            XCTAssert(message == testMessage.message)
            messageExpectation.fulfill()
        }
        
        mockChatBox.sendMessage(socketID: mockChatBox.socketID!, message: testMessage)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testAddNewMessage() {
        let message = "TEST_MESSAGE"
        let testSender = "TEST_SENDER"
        self.mockChatBox.addIncomingMessage(name: testSender, message: message, socketID: self.mockChatBox.socketID!)
        XCTAssert(self.mockChatBox.messages.count == 1)
    }
    
    //MARK: MOCK CLASSES
    class MockSocket: Socketable {
        //TEST PROPERTIES
        var handlers: [String: NormalCallback] = [:]
        
        typealias MessageSentCompletion = (_ eventName: String, _ willies: Int, _ message: String) -> ()
        var testCompletion: MessageSentCompletion?
        
        
        func emit(_ event: String, _ items: SocketData...) {
            testCompletion?(event, items[0] as! Int, items[1] as! String)
        }
        
        func connect() { }
        func disconnect() { }
        func on(_ event: String, callback: @escaping NormalCallback) -> UUID {
            self.handlers[event] = callback
            return UUID()
        }
    }
    
    class MockChatBox: ChatBox, SocketIO {
        var messages: [SpeechBubbleMessage] = []
        var sendBtn: UIButton! = UIButton()
        var formField: UITextField! = UITextField()
        var disposeBag: DisposeBag! = DisposeBag()
        
        var resetAck: SocketAckEmitter?
        var socket: Socketable?
        var socketID: Int? = 0
        
        func updateUIWithMessage(message: Message) {
            
        }
        
        func configureSocket() {
            self.socket = MockSocket()
        }
    }
}
