//
//  ChadModelTests.swift
//  ChadGPTTests
//
//  Created by Felix Schindler on 14.06.23.
//

import XCTest
@testable import ChadGPT

final class ChadModelTests: XCTestCase {
    
    private var chadModel: ChadModel!
    
    override func setUp() {
        super.setUp()
        chadModel = ChadModel.shared
    }
    
    override func tearDown() {
        chadModel = nil
        super.tearDown()
    }
    
    func testSendMessage() async throws {
        let messages : [Message] = [
        Message(role: "user", content: "Hi"),
        Message(role: "system", content: "Hello")
        ]
        let apiRes = await chadModel.sendMessage(messages)
        XCTAssertTrue(apiRes.isNotEmpty)
    }
    
    func testSettings() async {
        chadModel.settings = ChadSettings(style: .cute, name: "Cardi B")
        
        XCTAssertEqual(chadModel.settings.style, .cute)
        XCTAssertEqual(chadModel.settings.name, "Cardi B")
        
        XCTAssertEqual(chadModel.settings.style, ChadModel.shared.settings.style)
        XCTAssertEqual(chadModel.settings.name, ChadModel.shared.settings.name)
    }
}
