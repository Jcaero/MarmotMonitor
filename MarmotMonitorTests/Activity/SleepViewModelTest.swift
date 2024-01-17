//
//  SleepViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 17/01/2024.
//

import Foundation
import XCTest
@testable import MarmotMonitor

class SleepViewModelTest: XCTestCase {
    private var viewModel: SleepViewModel!
    
    private var isDataUpdate: Bool!
    private var duration: String!

    override func setUp() {
        super.setUp()
        viewModel = SleepViewModel(delegate: self)
        isDataUpdate = false
        duration = ""
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testSleepHasNoData_WhenSetDateAndSelectedZero_DataIsSaveAndRequestUpdate() {
        let date = Date()
        let stringDate = date.toStringWithTimeAndDayMonthYear()
        
        viewModel.setSelectedLabel(with: 0)
        viewModel.setDate(with: date)
        
        XCTAssertTrue(isDataUpdate)
        XCTAssertEqual(viewModel.sleepData[0], stringDate)
    }

    func testSleepHasNoData_WhenSetDateAndSelectedOne_DataIsSaveAndRequestUpdate() {
        let date = Date()
        let stringDate = date.toStringWithTimeAndDayMonthYear()
        
        viewModel.setSelectedLabel(with: 1)
        viewModel.setDate(with: date)
        
        XCTAssertTrue(isDataUpdate)
        XCTAssertEqual(viewModel.sleepData[1], stringDate)
    }

    func testSleepHasNoData_WhenSetSelectedOutOfRange_dataIsNotSave() {
        let date = Date()

        viewModel.setSelectedLabel(with: 5)
        viewModel.setDate(with: date)

        XCTAssertFalse(isDataUpdate)
        XCTAssertEqual(viewModel.sleepData[0], "Pas encore de date")
        XCTAssertEqual(viewModel.sleepData[1], "Pas encore de date")
    }

    // MARK: - Clear data
    func testSleepHasData_WhenSetSelectedOneAndClearData_dataIsClear() {
        let date = Date()
        let stringDate = date.toStringWithTimeAndDayMonthYear()
        
        viewModel.setSelectedLabel(with: 1)
        viewModel.setDate(with: date)
        
        XCTAssertTrue(isDataUpdate)
        XCTAssertEqual(viewModel.sleepData[1], stringDate)

        viewModel.clearDate()
        XCTAssertEqual(viewModel.sleepData[1], "Pas encore de date")
    }

    // MARK: - Duration
    func testWhenSetTwoGoodData_durationIsUpdate() {
        let startedDate = Date()
        let endDate = Date().addingTimeInterval(3600)
        
        viewModel.setSelectedLabel(with: 0)
        viewModel.setDate(with: startedDate)
        viewModel.setSelectedLabel(with: 1)
        viewModel.setDate(with: endDate)
        
        XCTAssertTrue(isDataUpdate)
        XCTAssertEqual(duration, "1h 0min")
    }

    func testWhenSetNotGoodData_durationIsNotUpdate() {
        let startedDate = Date()
        let endDate = Date().addingTimeInterval(3600)
        
        viewModel.setSelectedLabel(with: 0)
        viewModel.setDate(with: endDate)
        viewModel.setSelectedLabel(with: 1)
        viewModel.setDate(with: startedDate)
        
        XCTAssertTrue(isDataUpdate)
        XCTAssertEqual(duration, "erreur de date")
    }
}

extension SleepViewModelTest: SleepDelegate {
    func updateData() {
        isDataUpdate = true
    }
    
    func updateDuration(with duration: String) {
        self.duration = duration
    }
}
