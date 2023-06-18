//
//  ViewHelperTest.swift
//  ChadGPTTests
//
//  Created by Elisa Zhang on 18.06.23.
//

import XCTest
@testable import ChadGPT

final class ViewHelperTest: XCTestCase {
    
    var viewHelper: ViewHelper!
    
    override func setUp() {
        super.setUp()
        viewHelper = ViewHelper()
    }
    
    override func tearDown() {
        viewHelper = nil
        super.tearDown()
    }
    
    func testReloadStarredList() {
        let starredList = viewHelper.reloadStarredList()
        XCTAssertNotNil(starredList)
    }
    
    func testLoadChatHistory() {
        let chatMessages: [Message] = [
            Message(role: "User", content: "Hello"),
            Message(role: "Bot", content: "Hi there"),
            Message(role: "User", content: "How are you?")
        ]
        for message in chatMessages {
            DataManager.shared.saveChatHistory(role: message.role, message: message.content)
        }
        
        
        let chatHistory = viewHelper.loadChatHistory()
        XCTAssertEqual(chatHistory.count, 3)
        XCTAssertEqual(chatHistory[0].role, "User")
        XCTAssertEqual(chatHistory[0].content, "Hello")
        XCTAssertEqual(chatHistory[1].role, "Bot")
        XCTAssertEqual(chatHistory[1].content, "Hi there")
        XCTAssertEqual(chatHistory[2].role, "User")
        XCTAssertEqual(chatHistory[2].content, "How are you?")
    }
    
    func testGeneratePickUpLine() async {
        let userInput = "User input"
        let pickupLines = await viewHelper.generatePickUpLine(userInput: userInput)
        XCTAssertNotNil(pickupLines)
    }
}
