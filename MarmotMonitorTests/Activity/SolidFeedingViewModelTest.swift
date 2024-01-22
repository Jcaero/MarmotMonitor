//
//  SolidFeedingViewModel.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 17/01/2024.
//

import XCTest
@testable import MarmotMonitor

class SolidFeedingViewModelTest: TestCase {

    private var viewModel: SolidFeedingViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!
    
    private var totalFood: String!
    private var isNextView: Bool!
    private var alertMessage: String!

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = SolidFeedingViewModel(delegate: self, coreDataManager: coreDatatManager)
        totalFood = "0"
        isNextView = false
        alertMessage = ""
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }
    
    func testWhenSetOneIngredient_IngredientIsInsert() {
        
        viewModel.set("100", for: .cereal)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], 100)
        XCTAssertEqual(viewModel.solidFood[.fruit], nil)
        XCTAssertEqual(totalFood, "Total = 100 g")
        
    }

    func testWhenSetTwoIngredients_IngredientsIsInsert() {
        
        viewModel.set("100", for: .cereal)
        viewModel.set("200", for: .fruit)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], 100)
        XCTAssertEqual(viewModel.solidFood[.fruit], 200)
        XCTAssertEqual(viewModel.solidFood[.meat], nil)
        XCTAssertEqual(totalFood, "Total = 300 g")
    }

    func testWhenSetString_IngredientsIsNotInsert() {
        
        viewModel.set("test", for: .cereal)
        viewModel.set("200", for: .fruit)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], nil)
        XCTAssertEqual(viewModel.solidFood[.fruit], 200)
        XCTAssertEqual(totalFood, "Total = 200 g")
    }

    func testWhenSetNegatifNumbers_IngredientsIsNotInsert() {
        
        viewModel.set("-100", for: .cereal)
        viewModel.set("200", for: .fruit)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], nil)
        XCTAssertEqual(viewModel.solidFood[.fruit], 200)
        XCTAssertEqual(totalFood, "Total = 200 g")
    }

    // MARK: - Core Data
    func testNoSolidSet_WhenSaveDiaper_NoDiaperIsSave() {

        viewModel.saveSolid(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 0)
    }

    func testSolidSet_WhenSave_SolidIsSave() {
        let startedDateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(startedDateActivities.count, 0)
        
        viewModel.set("100", for: .cereal)
        viewModel.set("50", for: .fruit)
        viewModel.saveSolid(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let total = (dateActivities.first?.activityArray.first as! Solid).total
        XCTAssertEqual(total, 150)
    }

    // MARK: - Alert
    func testSolidIsSave_WhenSaveSolid_ShowAlerte() {

        viewModel.set("100", for: .meat)
        viewModel.set("50", for: .dairyProduct)
        viewModel.saveSolid(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        XCTAssertEqual(dateActivities.count, 1)
    
        viewModel.set("100", for: .fruit)
        viewModel.saveSolid(at: testFirstDateSeven)

        let total = (dateActivities.first?.activityArray.first as! Solid).total
        XCTAssertEqual(total, 150)
        XCTAssertEqual(alertMessage, ActivityType.solidAlert)
    }

}

extension SolidFeedingViewModelTest: SolideFeedingProtocol {
    func nextView() {
        isNextView = true
    }
    
    func alert(title: String, description: String) {
        alertMessage = description
    }
    
    func updateTotal(with total: String) {
        totalFood = total
    }
}
