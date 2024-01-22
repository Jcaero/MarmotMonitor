//
//  GrowthViewmodelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 22/01/2024.
//

import XCTest
@testable import MarmotMonitor

class GrowthViewmodelTest: TestCase {
    private var viewModel: GrowthViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!
    
    private var isDataUpdate: Bool!
    private var alerteMessage: String!
    private var isNextView: Bool!
    
    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = GrowthViewModel(delegate: self, coreDataManager: coreDatatManager)
        isDataUpdate = false
        alerteMessage = ""
        isNextView = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }

    // MARK: - Groth Set
    func testNoGrowthIsSet_WhenSetGrowthWeight_GrowthIsSetAndUpdateData() {
        viewModel.setGrowth(with: "25", inPosition: 0)
        
        XCTAssertEqual(viewModel.growthData[GrowthField.height.title], 25)
        XCTAssertEqual(viewModel.growthData[GrowthField.weight.title], nil)
        XCTAssertEqual(viewModel.growthData[GrowthField.head.title], nil)
        XCTAssertTrue(isDataUpdate)
    }

    func testNoGrowthIsSet_WhenSetGrowthHeight_GrowthIsSetAndUpdateData() {
        viewModel.setGrowth(with: "25", inPosition: 1)
        
        XCTAssertEqual(viewModel.growthData[GrowthField.height.title], nil)
        XCTAssertEqual(viewModel.growthData[GrowthField.weight.title], 25)
        XCTAssertEqual(viewModel.growthData[GrowthField.head.title], nil)
        XCTAssertTrue(isDataUpdate)
    }

    func testNoGrowthIsSet_WhenSetGrowthHead_GrowthIsSetAndUpdateData() {
        viewModel.setGrowth(with: "25", inPosition: 2)
        
        XCTAssertEqual(viewModel.growthData[GrowthField.height.title], nil)
        XCTAssertEqual(viewModel.growthData[GrowthField.weight.title], nil)
        XCTAssertEqual(viewModel.growthData[GrowthField.head.title], 25)
        XCTAssertTrue(isDataUpdate)
    }

    func testNoGrowthIsSet_WhenSetAlGrowth_GrowthIsSetAndUpdateData() {
        viewModel.setGrowth(with: "50.0", inPosition: 0)
        viewModel.setGrowth(with: "25.7", inPosition: 1)
        viewModel.setGrowth(with: "30", inPosition: 2)
        
        XCTAssertEqual(viewModel.growthData[GrowthField.height.title], 50.0)
        XCTAssertEqual(viewModel.growthData[GrowthField.weight.title], 25.7)
        XCTAssertEqual(viewModel.growthData[GrowthField.head.title], 30)
        XCTAssertTrue(isDataUpdate)
    }

    func testNoGrowthIsSet_WhenSetGrowthOutRange_NoGrowthIsSet() {
        viewModel.setGrowth(with: "25", inPosition: 4)
        
        XCTAssertEqual(viewModel.growthData[GrowthField.weight.title], nil)
        XCTAssertEqual(viewModel.growthData[GrowthField.height.title], nil)
        XCTAssertEqual(viewModel.growthData[GrowthField.head.title], nil)
        XCTAssertFalse(isDataUpdate)
    }

    // MARK: - save Groth
    func testNoDiaperSet_WhenSaveDiaper_NoDiaperIsSave() {
        viewModel.saveGrowth(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 0)
    }

    func testDiaperWetSet_WhenSaveDiaper_DiaperIsSave() {
        let startedDateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(startedDateActivities.count, 0)
        
        viewModel.setGrowth(with: "50.0", inPosition: 0)
        viewModel.saveGrowth(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let height = (dateActivities.first?.activityArray.first as! Growth).height
        XCTAssertEqual(height, 50.0)
    }

    // MARK: - Alert
    func testDiaperIsSave_WhenSaveDiaper_ShowAlerte() {

        viewModel.setGrowth(with: "50.0", inPosition: 0)
        viewModel.saveGrowth(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        XCTAssertEqual(dateActivities.count, 1)

        viewModel.saveGrowth(at: testFirstDateSeven)
        XCTAssertEqual(alerteMessage, ActivityType.growthAlert)
    }

}

extension GrowthViewmodelTest: GrowthDelegate {
    func nextView() {
        isNextView = true
    }
    
    func alert(title: String, description: String) {
        alerteMessage = description
    }
    
    func updateData() {
        isDataUpdate = true
    }
}
