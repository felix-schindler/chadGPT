//
//  GeneratorViewUITests.swift
//  ChadGPTUITests
//
//  Created by Felix Schindler on 15.06.23.
//

import XCTest

class GeneratorViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGenerate() {
        let collectionViewsQuery = app.collectionViews
        let userPromptTextField = collectionViewsQuery.textFields["user-prompt"]
        userPromptTextField.tap()
        userPromptTextField.typeText("She's the best singer in the world")
        collectionViewsQuery.buttons["line-generator-button"].tap()
        
        let pickupLinesSection = collectionViewsQuery.staticTexts["Pickup lines"]
        
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: pickupLinesSection, handler: nil)
        
        waitForExpectations(timeout: 10, handler: nil)  // Adjust the timeout as needed.
        
        XCTAssertTrue(pickupLinesSection.exists)
    }
}
