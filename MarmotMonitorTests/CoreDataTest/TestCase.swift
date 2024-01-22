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
    
    let sleeptestCaseStarted = "07/01/2024 22:30".toDateWithTime() ?? Date()
    let sleeptestCaseEnd = "07/01/2024 23:30".toDateWithTime() ?? Date()

    let solidData1 = SolidQuantity(vegetable: 250,
                                  meat: 250,
                                  fruit: 250,
                                  dairyProduct: 250,
                                  cereal: 250,
                                  other: 250)

    let solidData2 = SolidQuantity(vegetable: 100,
                                  meat: 100,
                                  fruit: 100,
                                  dairyProduct: 100,
                                  cereal: 100,
                                  other: 100)
}
