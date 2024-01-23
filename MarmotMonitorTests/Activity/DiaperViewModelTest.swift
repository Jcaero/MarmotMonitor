//
//  DiaperViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 18/01/2024.
//
import XCTest
@testable import MarmotMonitor

class DiaperViewModelTest: TestCase {

    private var viewModel: DiaperViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!

    private var isDataUpdate: Bool!
    private var alerteMessage: String!
    private var isNextView: Bool!

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = DiaperViewModel(delegate: self, coreDataManager: coreDatatManager)
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
    
    // MARK: - Diaper Set
    func testNoDiaperIsSet_WhenSetDiaperWet_diaperIsSetAndUpdateData() {
        viewModel.selectDiaper(diaper: .wet)
        
        XCTAssertTrue(viewModel.diaperStatus[.wet]!)
        XCTAssertFalse(viewModel.diaperStatus[.dirty]!)
        XCTAssertFalse(viewModel.diaperStatus[.both]!)
        XCTAssertTrue(isDataUpdate)
    }

    func testNoDiaperIsSet_WhenSetDiaperDirty_diaperIsSetAndUpdateData() {
        viewModel.selectDiaper(diaper: .dirty)
        
        XCTAssertFalse(viewModel.diaperStatus[.wet]!)
        XCTAssertTrue(viewModel.diaperStatus[.dirty]!)
        XCTAssertFalse(viewModel.diaperStatus[.both]!)
        XCTAssertTrue(isDataUpdate)
    }

    func testNoDiaperIsSet_WhenSetDiaperBoth_diaperIsSetAndUpdateData() {
        viewModel.selectDiaper(diaper: .both)
        
        XCTAssertFalse(viewModel.diaperStatus[.wet]!)
        XCTAssertFalse(viewModel.diaperStatus[.dirty]!)
        XCTAssertTrue(viewModel.diaperStatus[.both]!)
        XCTAssertTrue(isDataUpdate)
    }

    // MARK: - Diaper Reset
    func testDiaperIsSet_WhenSetAnother_diaperIsChangeAndUpdateData() {
        viewModel.selectDiaper(diaper: .wet)
        
        XCTAssertTrue(viewModel.diaperStatus[.wet]!)
        XCTAssertFalse(viewModel.diaperStatus[.dirty]!)
        XCTAssertFalse(viewModel.diaperStatus[.both]!)
        
        viewModel.selectDiaper(diaper: .both)
        
        XCTAssertFalse(viewModel.diaperStatus[.wet]!)
        XCTAssertFalse(viewModel.diaperStatus[.dirty]!)
        XCTAssertTrue(viewModel.diaperStatus[.both]!)
        
        XCTAssertTrue(isDataUpdate)
    }

    // MARK: - Core Data
    func testNoDiaperSet_WhenSaveDiaper_NoDiaperIsSave() {

        viewModel.saveDiaper(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 0)
    }

    func testDiaperWetSet_WhenSaveDiaper_DiaperIsSave() {
        let startedDateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(startedDateActivities.count, 0)
        
        viewModel.selectDiaper(diaper: .wet)
        viewModel.saveDiaper(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, DiaperState.wet.rawValue)
    }

    // MARK: - Alert
    func testDiaperIsSave_WhenSaveDiaper_ShowAlerte() {
        let diaperAlert = mockDiaper.alertMessage
        viewModel.selectDiaper(diaper: .wet)
        viewModel.saveDiaper(at: testFirstDateSeven)
        
        let dateActivities = coreDatatManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        XCTAssertEqual(dateActivities.count, 1)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, DiaperState.wet.rawValue)

        viewModel.saveDiaper(at: testFirstDateSeven)
        XCTAssertEqual(alerteMessage, ActivityType.diaperAlert)
    }

}

extension DiaperViewModelTest: DiaperDelegate {
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

