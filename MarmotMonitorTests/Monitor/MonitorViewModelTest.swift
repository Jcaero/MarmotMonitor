//
//  MonitorViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 25/01/2024.
//

import XCTest
@testable import MarmotMonitor

final class MonitorViewModelTest: TestCase {

    private var viewModel: MonitorViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!

    private var isSave: Bool!

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = MonitorViewModel(saveManager: coreDatatManager)
        
        isSave = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }
    
    func testCoreDataHaveBottle_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.bottle(quantity: 100), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .blue)
        XCTAssertEqual(graphInfo?.duration, 29)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSeven)
        XCTAssertEqual(graphInfo?.type, .bottle)
    }

    func testCoreDataHaveDiaper_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.diaper(state: .both), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .yellow)
        XCTAssertEqual(graphInfo?.duration, 29)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSeven)
        XCTAssertEqual(graphInfo?.type, .diaper)
    }

    func testCoreDataHaveBreast_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.breast(duration: mockBreastDurationFifteenAndTen), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .red)
        XCTAssertEqual(graphInfo?.duration, 0)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSeven)
        XCTAssertEqual(graphInfo?.type, .breast)
    }

    func testCoreDataHaveSolid_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.solid(composition: mockSolidQuantity1), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .green)
        XCTAssertEqual(graphInfo?.duration, 29)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSeven)
        XCTAssertEqual(graphInfo?.type, .solid)
    }

    func testCoreDataHaveSleep_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.sleep(duration: 360), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .purple)
        XCTAssertEqual(graphInfo?.duration, 6)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSeven)
        XCTAssertEqual(graphInfo?.type, .sleep)
    }

    //MARK: - test many Data
    func testCoreDataHaveManySleep_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.sleep(duration: 360), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        coreDatatManager.saveActivity(.sleep(duration: 80), date: testFirstDateSevenAtFive, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .purple)
        XCTAssertEqual(graphInfo?.duration, 1)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSevenAtFive)
        XCTAssertEqual(graphInfo?.type, .sleep)

        let graphInfo2 = viewModel.graphActivities["07/01/2024"]?[1]
        XCTAssertEqual(graphInfo2?.color, .purple)
        XCTAssertEqual(graphInfo2?.duration, 6)
        XCTAssertEqual(graphInfo2?.timeStart, testFirstDateSeven)
        XCTAssertEqual(graphInfo2?.type, .sleep)
    }

    //MARK: - test Activity Unknown in  Data
    func testCoreDataHaveGrowth_WhenUpdateData_ViewModelHaveNoData() {
        coreDatatManager.saveActivity(.growth(data: mockGrowthData), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })

        
        viewModel.updateData()
        
        XCTAssertEqual(viewModel.dateWithActivity.count, 0)
        XCTAssertEqual(viewModel.graphActivities.count, 0)
    
    }

    //MARK: - test Summary Activity
    func testCoreDataHaveData_WhenSummary_ViewModelHaveSummary() {
        coreDatatManager.saveActivity(.breast(duration: mockBreastDurationFifteenAndTen), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let summaryOfSeven = viewModel.summaryActivities["07/01/2024"]
        XCTAssertEqual(summaryOfSeven![ActivityIconName.meal.rawValue], "25 min\n1 fois")
    
    }

    func testCoreDataHaveSleepData_WhenSummary_ViewModelHaveSummary() {
        coreDatatManager.saveActivity(.sleep(duration: 10800), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 1)
        XCTAssertEqual(viewModel.dateWithActivity[0], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 1)
        
        let summaryOfSeven = viewModel.summaryActivities["07/01/2024"]
        XCTAssertEqual(summaryOfSeven![ActivityIconName.sleep.rawValue], "03 H\n1 fois")
    
    }
}
