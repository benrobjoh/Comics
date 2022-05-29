//
//  ComicsUITests.swift
//  ComicsUITests
//
//  Created by Ben Johnson on 2022-05-28.
//

import XCTest

class ComicsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

    }
}
