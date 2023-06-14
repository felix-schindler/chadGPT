//
//  DataManagerTests.swift
//  ChadGPTTests
//
//  Created by Felix Schindler on 14.06.23.
//

import Foundation
import XCTest
@testable import ChadGPT

class DataManagerTests: XCTestCase {
    
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager.shared
    }
    
    override func tearDown() {
        dataManager = nil
        super.tearDown()
    }
    
    func testSaveChatHistory() {
        let role = "user"
        let message = "Hello, world!"
        dataManager.saveChatHistory(role: role, message: message)
        
        let fetchRequest = ChatHistory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "role == %@ AND message == %@", role, message)
        
        do {
            let chatHistory = try dataManager.viewContext.fetch(fetchRequest).first
            XCTAssertNotNil(chatHistory)
            XCTAssertEqual(chatHistory?.role, role)
            XCTAssertEqual(chatHistory?.message, message)
        } catch {
            XCTFail("Failed to fetch chat history: \(error)")
        }
    }
}
