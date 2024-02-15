//
//  ApparenceAuditAccessibility.swift
//  MarmotMonitorUITests
//
//  Created by pierrick viret on 15/02/2024.
//

import XCTest
@testable import MarmotMonitor

final class ApparenceAuditAccessibility: XCTestCase {
    
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
    
    func testAccessibilityApparence() throws {
        #warning("faire audit")
        let app = UIApplication()
        app.launch()
        app.buttons["Réglage"].tap()
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(matching: .cell, identifier: "MyCell_Apparence")
        cell.tap()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }
}
