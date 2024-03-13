//
//  settingAuditAccessibilityTests.swift
//  MarmotMonitorUITests
//
//  Created by pierrick viret on 16/02/2024.
//
import XCTest
@testable import MarmotMonitor

final class SettingAuditAccessibility: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    func testAccessibilityApparence() throws {
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

    func testAccessibilityIcone() throws {
        let app = UIApplication()
        app.launch()
        app.buttons["Réglage"].tap()
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(matching: .cell, identifier: "MyCell_IconeCouleur")
        cell.tap()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func testAccessibilityGraph() throws {
        let app = UIApplication()
        app.launch()
        app.buttons["Réglage"].tap()
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(matching: .cell, identifier: "MyCell_graphType")
        cell.tap()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }

    func testAccessibilityInfo() throws {
        let app = UIApplication()
        app.launch()
        app.buttons["Réglage"].tap()
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(matching: .cell, identifier: "MyCell_Information")
        cell.tap()
        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }

//    func testSetting() throws {
//        let app = UIApplication()
//        app.launchArguments = ["UI_TESTING"]
//        app.launch()
//        app.buttons["Réglage"].tap()
//        if #available(iOS 17.0, *) {
//            try app.performAccessibilityAudit()
//        } else {
//            // Fallback on earlier versions
//        }
//    }
}
