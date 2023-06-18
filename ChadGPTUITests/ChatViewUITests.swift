//
//  ChatViewUITests.swift
//  ChadGPTUITests
//
//  Created by Felix Schindler on 15.06.23.
//

import XCTest

class ChatViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSendMessage() {
        // Assert app launched
        XCTAssertTrue(app.exists)
        
        // Navigate to chat view
        app.tabBars["Tab Bar"].buttons["Chat"].tap()
        
        // Enter a new message
        let userPromptTextField = app.textFields["user-msg"]
        userPromptTextField.tap()
        userPromptTextField.typeText("Hello, my name is Felix")
        
        // Send the message
        let sendButton = app.buttons["send-msg"]
        sendButton.tap()
        
        XCTAssertTrue(sendButton.exists)
    }
    
    func testSettings() {
        // Navigate to chat view
        app.tabBars["Tab Bar"].buttons["Chat"].tap()
        
        // Open ChatSettingsView
        app.navigationBars.buttons["open-settings"].tap()
        let saveButton = app.navigationBars["Settings"].buttons["Save"]
        XCTAssertTrue(saveButton.exists)
    }
    
}
