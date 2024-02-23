//
//  TodayAuditAccessibility.swift
//  MarmotMonitorUITests
//
//  Created by pierrick viret on 23/02/2024.
//
import XCTest
@testable import MarmotMonitor

final class TodayAuditAccessibility: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = true
    }
    
    func testAccessibilityMonitor() throws {
        let app = UIApplication()
        app.launch()

        if #available(iOS 17.0, *) {
            try app.performAccessibilityAudit()
        } else {
            // Fallback on earlier versions
        }
    }
}
