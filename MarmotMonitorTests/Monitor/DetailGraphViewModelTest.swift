//
//  DetailGraphViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 22/02/2024.
//

import XCTest
@testable import MarmotMonitor

final class DetailGraphViewModelTest: TestCase {
    private var viewModel: DetailGraphViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = DetailGraphViewModel(coreDataManager: coreDatatManager)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }

    func testNoDataInViewModel_WhenSetData_ViewModelHaveData() {
        XCTAssertEqual(viewModel.numberOfRow, 0)

        let date = Date()
        let data = [GraphActivity(type: .bottle, color: .red, timeStart: date, duration: 25, quantity: 25)]
        viewModel.setDatas(data: data)
        
        XCTAssertEqual(viewModel.numberOfRow, 1)
    }

    //MARK: - Test getValue
    func testHaveDiaper_WhenGetValue_HaveNoString() {
        let date = Date()
        let data = [GraphActivity(type: .diaper, color: .red, timeStart: date, duration: 25, quantity: 25)]
        viewModel.setDatas(data: data)
        
        let value = viewModel.getValue(for: 0)

        XCTAssertEqual(value, "")
    }

    func testHaveBottle_WhenGetValue_HaveData() {
        let date = Date()
        let data = [GraphActivity(type: .bottle, color: .red, timeStart: date, duration: 25, quantity: 25)]
        viewModel.setDatas(data: data)
        
        let value = viewModel.getValue(for: 0)

        XCTAssertEqual(value, "25 ml")
    }

    func testHaveBottleWithNoQuantity_WhenGetValue_HaveNoData() {
        let date = Date()
        let data = [GraphActivity(type: .bottle, color: .red, timeStart: date, duration: 25)]
        viewModel.setDatas(data: data)
        
        let value = viewModel.getValue(for: 0)

        XCTAssertEqual(value, "")
    }

    func testHaveSleep_WhenGetValue_HaveDuration() {
        let date = Date()
        let data = [GraphActivity(type: .sleep, color: .red, timeStart: date, duration: 3700, quantity: 0)]
        viewModel.setDatas(data: data)
        
        let value = viewModel.getValue(for: 0)

        XCTAssertEqual(value, "01 H 01 min")
    }

    //MARK: - Test deleteActivity
    func testDeleteActivity_WhenDeleteActivity_ActivityIsDeleted() {
        coreDatatManager.saveActivity(.diaper(state: .wet),
                                              date: testFirstDateSeven,
                                              onSuccess: { } ,
                                              onError: { _ in})


        let date = testFirstDateSeven
        let data = [GraphActivity(type: .diaper, color: .red, timeStart: date, duration: 3700, quantity: 0)]
        viewModel.setDatas(data: data)

        viewModel.deleteActivity(at: 0, completion: {
            XCTAssertEqual(self.viewModel.numberOfRow, 0)
        })
        XCTAssertEqual(self.viewModel.numberOfRow, 0)
    }

    func testNoActivity_WhenDeleteActivity_Error() {

        let date = testFirstDateSeven
        let data = [GraphActivity(type: .diaper, color: .red, timeStart: date, duration: 3700, quantity: 0)]
        viewModel.setDatas(data: data)

        viewModel.deleteActivity(at: 0, completion: {
            XCTAssertEqual(self.viewModel.numberOfRow, 1)
        })
        XCTAssertEqual(self.viewModel.numberOfRow, 1)
    }
}


