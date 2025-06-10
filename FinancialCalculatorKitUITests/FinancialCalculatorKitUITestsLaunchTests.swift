//
//  FinancialCalculatorKitUITestsLaunchTests.swift
//  FinancialCalculatorKitUITests
//
<<<<<<< HEAD
//  Created by Roger Lin on 6/9/25.
=======
//  Created by Roger Lin on 6/8/25.
>>>>>>> create-feature-rich-financial-calculator-app
//

import XCTest

final class FinancialCalculatorKitUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
