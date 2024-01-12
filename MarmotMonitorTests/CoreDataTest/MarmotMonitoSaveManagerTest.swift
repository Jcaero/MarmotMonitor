//
//  MarmotMonitoSaveManagerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 07/01/2024.
//


import XCTest
@testable import MarmotMonitor

final class MarmotMonitoSaveManagerTest: TestCase {
    var marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol!
    static var needLoad: Bool = true
    
    override func setUpWithError() throws {
        marmotMonitorSaveManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        if MarmotMonitoSaveManagerTest.needLoad {
            CoreDataManagerMock.sharedInstance.load()
            MarmotMonitoSaveManagerTest.needLoad = false
        }
    }
    
    override func tearDownWithError() throws {
        marmotMonitorSaveManager.clearDatabase()
        marmotMonitorSaveManager = nil
    }

    // MARK: - Test ClearDatabase
    func testCoreDataHaveDate_WhenCallClearDataBase_CoreDataHaveNoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)

        let dateActivitiesStarted = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDateSix, to: activityEndDateEight)
        
        marmotMonitorSaveManager.clearDatabase()
        
        let dateActivitiesEnded = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDateSix, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivitiesStarted.count, 1)
        XCTAssertEqual(dateActivitiesEnded.count, 0)
    }

    // MARK: - SaveActivity
    func testCoreDataHaveNoData_WhenSaveActivity_CoreDataHaveData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, State.wet.rawValue)
    }

    func testCoreDataHaveData_WhenSaveActivity_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.diaper(state:.both), date: testSecondDateSix)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testSecondDateSix, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 2)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, State.both.rawValue)
    }



    
    func testCoreDataAvecDatePlayground() {
        
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.diaper(state: .both), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.diaper(state: .both), date: testThirdDateFive)
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDateSix, to: activityEndDateEight)
        print ("dateActivities activityArray = \(dateActivities[0].activityArray.count)")
        let diapers = dateActivities.filter { $0.activityArray.contains(where: { $0 is Diaper }) }
        
        print ("dateActivities = \(dateActivities.count)")
        print ("diapers = \(diapers.count)")
        print ("\(String(describing: dateActivities[0].date))")
        
        if let firstDateActivity = diapers.first {
            firstDateActivity.activityArray.forEach { activity in
                if let diaper = activity as? Diaper {
                    print("Diaper state = \(String(describing: diaper.state))")
                }
            }
        }
    }
    
}
