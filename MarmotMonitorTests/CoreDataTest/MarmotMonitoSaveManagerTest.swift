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
        
        if let breast = dateActivities.first?.activityArray.first(where: { $0 is Breast }) as? Breast {
            XCTAssertEqual(breast.rightDuration, 120)
        } else {
            XCTFail("breast non trouvé")
        }
    }

    // MARK: - Activity Type Sleep
    func testCoreDataHaveNoData_WhenSaveActivityOfSleep_CoreDataHaveData() {
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 100), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let duration = (dateActivities.first?.activityArray.first as! Sleep).duration
        XCTAssertEqual(duration, 100)
    }

    func testCoreDataHaveData_WhenSaveActivityOfSleep_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 100), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 200), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let duration = (dateActivities.first?.activityArray.first as! Sleep).duration
        XCTAssertEqual(duration, 100)
        XCTAssertEqual(alerteDescription, ActivityType.sleep(duration: 100).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfSleepAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 100), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        XCTAssertEqual(dateActivities[0].activityArray.count, 2)
        

        if let sleep = dateActivities.first?.activityArray.first(where: { $0 is Sleep }) as? Sleep {
            XCTAssertEqual(sleep.duration, 100)
        } else {
            XCTFail("Sleep non trouvé")
        }
    }

    // MARK: - Growth
    func testCoreDataHaveNoData_WhenSaveActivityOfGrowth_CoreDataHaveData() {
        marmotMonitorSaveManager.saveActivity(.growth(weight: 370, height: 52, headCircumference: 26), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let weight = (dateActivities.first?.activityArray.first as! Growth).weight
        XCTAssertEqual(weight, 370)
    }

    func testCoreDataHaveData_WhenSaveActivityOfGrowth_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.growth(weight: 370, height: 52, headCircumference: 26), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.growth(weight: 500, height: 80, headCircumference: 40), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let weight = (dateActivities.first?.activityArray.first as! Growth).weight
        XCTAssertEqual(weight, 370)
        XCTAssertEqual(alerteDescription, ActivityType.growth(weight: 370, height: 52, headCircumference: 26).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfGrowthAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.growth(weight: 370, height: 52, headCircumference: 26), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        XCTAssertEqual(dateActivities[0].activityArray.count, 2)
        

        if let growth = dateActivities.first?.activityArray.first(where: { $0 is Growth }) as? Growth {
            XCTAssertEqual(growth.height, 52)
        } else {
            XCTFail("Growth non trouvé")
        }
    }

    // MARK: - Activity Type Solid
    func testCoreDataHaveNoData_WhenSaveActivityOfSolid_CoreDataHaveData() {

        marmotMonitorSaveManager.saveActivity(.solide(composition: solidData1), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let vegetable = (dateActivities.first?.activityArray.first as! Solid).vegetable
        XCTAssertEqual(vegetable, 250)
    }

    func testCoreDataHaveData_WhenSaveActivityOfSolid_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.solide(composition: solidData1), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.solide(composition: solidData2), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let vegetable = (dateActivities.first?.activityArray.first as! Solid).vegetable
        XCTAssertEqual(vegetable, 250)
        XCTAssertEqual(alerteDescription, ActivityType.solide(composition: solidData1).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfSolidAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: testFirstDateSeven)
        marmotMonitorSaveManager.saveActivity(.solide(composition: solidData1), date: testFirstDateSeven)
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        XCTAssertEqual(dateActivities[0].activityArray.count, 2)
        

        if let solid = dateActivities.first?.activityArray.first(where: { $0 is Solid }) as? Solid {
            XCTAssertEqual(solid.vegetable, 250)
        } else {
            XCTFail("solid non trouvé")
        }
    }
}

extension MarmotMonitoSaveManagerTest: MarmotMonitorSaveManagerDelegate {
    func showAlert(title: String, description: String) {
        alerteTitle = title
        alerteDescription = description
    }
}
