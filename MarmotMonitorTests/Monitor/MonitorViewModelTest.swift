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
        let baby = Person(name: nil, gender: .girl, parentName: nil, birthDay: nil)
        viewModel = MonitorViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby, graphType: .rod), saveManager: coreDatatManager)
        
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
        
        XCTAssertEqual(graphInfo?.color, .colorForMeal)
        XCTAssertEqual(graphInfo?.duration, 0)
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
        
        XCTAssertEqual(graphInfo?.color, .colorForDiaper)
        XCTAssertEqual(graphInfo?.duration, 0)
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
        
        XCTAssertEqual(graphInfo?.color, .colorForMeal)
        XCTAssertEqual(graphInfo?.duration, 1500)
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
        
        XCTAssertEqual(graphInfo?.color, .colorForMeal)
        XCTAssertEqual(graphInfo?.duration, 0)
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
        
        XCTAssertEqual(graphInfo?.color, .colorForSleep)
        XCTAssertEqual(graphInfo?.duration, 360)
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
        
        XCTAssertEqual(graphInfo?.color, .colorForSleep)
        XCTAssertEqual(graphInfo?.duration, 80)
        XCTAssertEqual(graphInfo?.timeStart, testFirstDateSevenAtFive)
        XCTAssertEqual(graphInfo?.type, .sleep)

        let graphInfo2 = viewModel.graphActivities["07/01/2024"]?[1]
        XCTAssertEqual(graphInfo2?.color, .colorForSleep)
        XCTAssertEqual(graphInfo2?.duration, 360)
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
        XCTAssertEqual(summaryOfSeven![ActivityIconName.meal.rawValue], "\n1 fois")
    
    }

    func testCoreDataHaveSleepData_WhenSummary_ViewModelHaveSummary() {
        coreDatatManager.saveActivity(.sleep(duration: 10800), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()

        XCTAssertTrue(viewModel.dateWithActivity.count == 2)
        XCTAssertEqual(viewModel.dateWithActivity[0], "08/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 2)
        
        let summaryOfSeven = viewModel.summaryActivities["07/01/2024"]
        XCTAssertEqual(summaryOfSeven![ActivityIconName.sleep.rawValue], "01 H 30 min\n1 fois")

        let summaryOfEight = viewModel.summaryActivities["08/01/2024"]
        XCTAssertEqual(summaryOfEight![ActivityIconName.sleep.rawValue], "01 H 30 min\n1 fois")
    
    }

    func testCoreDataHaveManyData_WhenSummary_ViewModelHaveSummary() {
        coreDatatManager.saveActivity(.sleep(duration: 10800), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        coreDatatManager.saveActivity(.breast(duration: mockBreastDurationFifteenAndTen), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 2)
        XCTAssertEqual(viewModel.dateWithActivity[1], "07/01/2024".toDate())
        XCTAssertEqual(viewModel.graphActivities.count, 2)
        
        let summaryOfSeven = viewModel.summaryActivities["07/01/2024"]
        XCTAssertEqual(summaryOfSeven![ActivityIconName.sleep.rawValue], "01 H 30 min\n1 fois")
        XCTAssertEqual(summaryOfSeven![ActivityIconName.meal.rawValue], "\n1 fois")
    }

    //MARK: - test get type graph
    func testUserDefaulHaveTypeGraph_WhenGetGraph_haveData() {
        
        
        let graph = viewModel.getGraphStyle()
        
        XCTAssertTrue(graph == .rod)
    }

    //MARK: - test togglefilter
    func test_WhenToggleFilter_filterChange() {
        viewModel.filterStatus = ["test":true]
        
        viewModel.toggleFilter(for: "test")
        
        XCTAssertTrue(viewModel.filterStatus["test"] == false)
    }

    func testfilterStatusHaveData_WhenRequestFilterButton_HaveFilterName() {
        viewModel.filterStatus = ["test":false, "test2":false]
        
        let array = viewModel.filterButton
        
        XCTAssertEqual(array, ["test2", "test"])
        
    }

    // MARK: - test activity is to long
    func testCoreDataHaveBreastAndDurationIsTolong_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.breast(duration: mockBreastDurationFifteenAndTen), date: testFourthDateSeven, onSuccess: {isSave = true }, onError: {_ in })
        print("mock date = \(testFourthDateSeven)")
        viewModel.updateData()
        
        XCTAssertTrue(viewModel.dateWithActivity.count == 2)
        XCTAssertEqual(viewModel.dateWithActivity[1].toStringWithDayMonthYear(), "07/01/2024")
        XCTAssertEqual(viewModel.graphActivities.count, 2)
        
        let graphInfo = viewModel.graphActivities["07/01/2024"]?.first
        
        XCTAssertEqual(graphInfo?.color, .colorForMeal)
        XCTAssertEqual(graphInfo?.duration, 600)
        XCTAssertEqual(graphInfo?.timeStart, testFourthDateSeven)
        XCTAssertEqual(graphInfo?.type, .breast)
    }
}
