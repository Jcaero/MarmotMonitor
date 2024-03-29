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
    let testFirstDateSevenAtFive = "07/01/2024 05:00".toDateWithTime() ?? Date()
    let testSecondDateSix = "06/01/2023".toDate() ?? Date()
    let testThirdDateFive = "05/01/2024".toDate() ?? Date()
    let testFourthDateSeven = "07/01/2024 23:50".toDateWithTime() ?? Date()

    let activityEndDateEight = "08/01/2024".toDate() ?? Date()
    let activityStartDateSix = "06/01/2024".toDate() ?? Date()
    
    let sleeptestCaseStarted = "07/01/2024 22:30".toDateWithTime() ?? Date()
    let sleeptestCaseEnd = "07/01/2024 23:30".toDateWithTime() ?? Date()

    let mockSolidQuantity1 = SolidQuantity(vegetable: 250,
                                  meat: 250,
                                  fruit: 250,
                                  dairyProduct: 250,
                                  cereal: 250,
                                  other: 250)

    let mockSolidQuantity2 = SolidQuantity(vegetable: 100,
                                  meat: 100,
                                  fruit: 100,
                                  dairyProduct: 100,
                                  cereal: 100,
                                  other: 100)

    let mockDiaper = ActivityType.diaper(state: .both)
    
    // MARK: - Mock ActivityType Breast
    let mockBreastFifteenAndTen = ActivityType.breast(duration: BreastDuration(leftDuration: 15, rightDuration: 10))
    let mockBreastDurationFifteenAndTen = BreastDuration(leftDuration: 900, rightDuration: 600)
    
    //MARK: - Mock Growth Data
    let mockGrowthData = GrowthData(weight: 10, height: 5.5, headCircumference: 20)
    let mockGrowthData2 = GrowthData(weight: 20, height: 11, headCircumference: 40)
    
    //MARK: - Mock Personn
    let mockNilPerson = Person(name: nil, gender: .girl, parentName: nil, birthDay: nil)
}
