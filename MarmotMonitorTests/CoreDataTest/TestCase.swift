//
//  TestCase.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 07/01/2024.
//

import Foundation
import XCTest
@testable import MarmotMonitor

class TestCase: XCTestCase {
    let testFirstDateSeven = "07/01/2024 22:30".toDateWithTime() ?? Date()
    let testSecondDateSix = "06/01/2023".toDate() ?? Date()
    let testThirdDateFive = "05/01/2024".toDate() ?? Date()

    let activityEndDateEight = "08/01/2024".toDate() ?? Date()
    let activityStartDateSix = "06/01/2024".toDate() ?? Date()
}
