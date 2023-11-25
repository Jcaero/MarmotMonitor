//
//  MarmotMonitorAuditAccessibility.swift
//  MarmotMonitorUITests
//
//  Created by pierrick viret on 25/11/2023.
//

import XCTest
@testable import MarmotMonitor

final class AccessibilityTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    func testAccessibility() throws {

        let app = XCUIApplication()
        app.launch()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }

    func testAccessibilityNomBaby() throws {

        let app = UIApplication()
        app.launch()
        app.commencerButton.tap()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }

    func testAccessibilityGender() throws {

        let app = UIApplication()
        app.launch()
        app.commencerButton.tap()
        app.textFields["Nom du bébé"].tap()
        app.textFields.element.typeText("test")
        app.textFields.element.typeText("\n")
        app.buttons["Suivant"].tap()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }
}
