//
//  SleepViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 17/01/2024.
//

import XCTest
@testable import MarmotMonitor

class SleepViewModelTest: TestCase {
    private var viewModel: SleepViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!

    private var isDataUpdate: Bool!
    private var duration: String!
    private var alerteMessage: String!
    private var isNextView: Bool!

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = SleepViewModel(delegate: self, coreDataManager: coreDatatManager)
        isDataUpdate = false
        duration = ""
        alerteMessage = ""
        isNextView = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
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
        XCTAssertEqual(duration, "")
        XCTAssertEqual(alerteMessage, "Erreur de date")
    }

    // MARK: - Core Data
    func testNoDateSet_WhenSaveSleep_NoSleepIsSave() {

        viewModel.saveSleep()
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 0)
    }

    func testDateSet_WhenSaveSleep_SleepIsSave() {
        viewModel.setSelectedLabel(with: 0)
        viewModel.setDate(with: sleeptestCaseStarted)
        viewModel.setSelectedLabel(with: 1)
        viewModel.setDate(with: sleeptestCaseEnd)
        
        XCTAssertTrue(isDataUpdate)
        XCTAssertEqual(duration, "1h 0min")
        
        viewModel.saveSleep()
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let duration = (dateActivities.first?.activityArray.first as! Sleep).duration
        XCTAssertEqual(duration, 3600)
    }

    // MARK: - Alert
    func testSleepIsSave_WhenSaveSleep_ShowAlerte() {
        viewModel.setSelectedLabel(with: 0)
        viewModel.setDate(with: sleeptestCaseStarted)
        viewModel.setSelectedLabel(with: 1)
        viewModel.setDate(with: sleeptestCaseEnd)
        
        viewModel.saveSleep()
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        XCTAssertEqual(dateActivities.count, 1)

        viewModel.saveSleep()
        XCTAssertEqual(alerteMessage, ActivityType.sleep(duration:  1).alertMessage)
    }

    func testNoData_WhenSave_ShowAlerte() {

        viewModel.saveSleep()
        XCTAssertEqual(alerteMessage!, "Aucune date rentrée")
    }

    func testOneNoData_WhenSave_ShowAlerte() {
        viewModel.setSelectedLabel(with: 0)
        viewModel.setDate(with: sleeptestCaseStarted)
        
        viewModel.saveSleep()
 
        XCTAssertEqual(alerteMessage!, "Aucune durée rentrée")
    }
}

extension SleepViewModelTest: SleepDelegate {
    func nextView() {
        isNextView = true
    }
    
    func alert(title: String, description: String) {
        alerteMessage = description
    }
    
    func updateData() {
        isDataUpdate = true
    }
    
    func updateDuration(with duration: String) {
        self.duration = duration
    }
}
