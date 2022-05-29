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

    func testAppPromptsForKeysIfNoneAreEntered() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.alerts["Marvel Comics API Key Required"].exists)
        // Public Key
        app.alerts.textFields.allElementsBoundByIndex[0].typeText("123")
        // Tap done
        app.alerts.buttons["Done"].tap()
        // Alert should disappear
        XCTAssertFalse(app.alerts["Marvel Comics API Key Required"].exists)

    }
}
