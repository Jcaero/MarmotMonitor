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
    
    var alerteTitle = ""
    var alerteDescription = ""
    
    override func setUpWithError() throws {
        marmotMonitorSaveManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance, delegate: self)
        if MarmotMonitoSaveManagerTest.needLoad {
            CoreDataManagerMock.sharedInstance.load()
            MarmotMonitoSaveManagerTest.needLoad = false
        }
    }
    
    override func tearDownWithError() throws {
        marmotMonitorSaveManager.clearDatabase()
        marmotMonitorSaveManager = nil
        alerteTitle = ""
        alerteDescription = ""
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
    func testCoreDataHaveNoData_WhenSaveActivity_CoreDataHaveOneData() {
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

    func testCoreDataHaveData_WhenSaveActivityAtSameDate_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.diaper(state:.both), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testThirdDateFive, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, State.wet.rawValue)
        XCTAssertEqual(alerteDescription, ActivityType.diaper(state: .wet).alertMessage)
    }

    // MARK: - Activity Type Bottle
    func testCoreDataHaveNoData_WhenSaveActivityOfBottle_CoreDataHaveData() {
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let quantity = (dateActivities.first?.activityArray.first as! Bottle).quantity
        XCTAssertEqual(quantity, 100)
    }

    func testCoreDataHaveData_WhenSaveActivityOfBottle_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 200), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let quantity = (dateActivities.first?.activityArray.first as! Bottle).quantity
        XCTAssertEqual(quantity, 100)
        XCTAssertEqual(alerteDescription, ActivityType.bottle(quantity: 100).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfBottleAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        XCTAssertEqual(dateActivities[0].activityArray.count, 2)
        

        if let bottle = dateActivities.first?.activityArray.first(where: { $0 is Bottle }) as? Bottle {
            XCTAssertEqual(bottle.quantity, 100)
        } else {
            XCTFail("Bottle non trouvé")
        }
    }

    // MARK: - Activity Type Breast
    func testCoreDataHaveNoData_WhenSaveActivityOfBreast_CoreDataHaveData() {
        let breastData = BreastDuration(leftDuration: 120, rightDuration: 120, first: .left)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastData), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let rightDuration = (dateActivities.first?.activityArray.first as! Breast).rightDuration
        XCTAssertEqual(Int(rightDuration), breastData.rightDuration)
    }

    func testCoreDataHaveData_WhenSaveActivityOfBreast_ShowAlerteAndNotSave() {
        let breastDataFirst = BreastDuration(leftDuration: 120, rightDuration: 120, first: .left)
        let breastDataSecond = BreastDuration(leftDuration: 200, rightDuration: 200, first: .right)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastDataFirst), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastDataSecond), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let rightDuration = (dateActivities.first?.activityArray.first as! Breast).rightDuration
        XCTAssertEqual(rightDuration, 120)
        XCTAssertEqual(alerteDescription, ActivityType.breast(duration: breastDataFirst).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfBreastAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        let breastData = BreastDuration(leftDuration: 120, rightDuration: 120, first: .left)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastData), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        XCTAssertEqual(dateActivities[0].activityArray.count, 2)
        
        let rightDuration = (dateActivities.first?.activityArray.first as! Breast).rightDuration
        if let breast = dateActivities.first?.activityArray.first(where: { $0 is Breast }) as? Breast {
            XCTAssertEqual(breast.rightDuration, 120)
        } else {
            XCTFail("breast non trouvé")
        }
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

extension MarmotMonitoSaveManagerTest: MarmotMonitorSaveManagerDelegate {
    func showAlert(title: String, description: String) {
        alerteTitle = title
        alerteDescription = description
    }
}
