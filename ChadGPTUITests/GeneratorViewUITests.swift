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
        // Räume nach jedem Test auf, wenn nötig
    }
    
    func testGenerate() {
    }
}
