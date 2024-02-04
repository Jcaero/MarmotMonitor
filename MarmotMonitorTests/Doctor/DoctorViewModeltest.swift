//
//  DoctorViewModeltest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 03/02/2024.
//

import XCTest
@testable import MarmotMonitor

final class DoctorViewModeltest: TestCase {
    
    private var viewModel: DoctorViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!
    
    private var isSave: Bool!
    
    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = DoctorViewModel(saveManager: coreDatatManager)
        
        isSave = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }
    func testCoreDataHaveBottle_WhenUpdateData_ViewModelHaveTheData() {
        coreDatatManager.saveActivity(.growth(data: mockGrowthData), date: testFirstDateSeven, onSuccess: {isSave = true }, onError: {_ in })

        coreDatatManager.saveActivity(.growth(data: mockGrowthData2), date: testSecondDateSix, onSuccess: {isSave = true }, onError: {_ in })
        
        viewModel.updateData()
        
        XCTAssertEqual(viewModel.heightValues.count, 2)
        XCTAssertEqual(viewModel.weightValues.count, 2)
    }
}
