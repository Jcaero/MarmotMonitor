//
//  BottleFeedingViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 21/01/2024.
//

import XCTest
@testable import MarmotMonitor

final class BottleFeedingViewModelTest: TestCase {

    private var viewModel: BottleFeedingViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!
    private var isDataUpdate: Bool!
    private var alerteMessage: String!
    private var isNextView: Bool!

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = BottleFeedingViewModel(delegate: self, coreDataManager: coreDatatManager)
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

    func testNoQuantitySet_WhenSaveBottle_NoBottleIsSave() {

        viewModel.saveBottle(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 0)
        XCTAssertEqual(alerteMessage, "Aucune quantité rentrée")
    }

    func testQuantitySet_WhenSaveBottle_BottleIsSave() {

        viewModel.setQuantity(100)
        viewModel.saveBottle(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let quantity = (dateActivities.first?.activityArray.first as! Bottle).quantity
        XCTAssertEqual(quantity, 100)
    }

}

extension BottleFeedingViewModelTest: BottleFeedingDelegate {
    func nextView() {
        isNextView = true
    }
    
    func alert(title: String, description: String) {
        alerteMessage = description
    }
}
