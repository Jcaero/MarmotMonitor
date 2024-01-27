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
    
    var saveActivity1 = false
    var saveActivity2 = false
    var alerteDescription = ""
    
    override func setUpWithError() throws {
        marmotMonitorSaveManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
    }
    
    override func tearDownWithError() throws {
        marmotMonitorSaveManager.clearDatabase()
        marmotMonitorSaveManager = nil
        saveActivity1 = false
        saveActivity2 = false
        alerteDescription = ""
    }

    // MARK: - Test ClearDatabase
    func testCoreDataHaveDate_WhenCallClearDataBase_CoreDataHaveNoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        let dateActivitiesStarted = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDateSix, to: activityEndDateEight)
        
        marmotMonitorSaveManager.clearDatabase()
        
        let dateActivitiesEnded = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDateSix, to: activityEndDateEight)
        
        XCTAssertTrue(saveActivity1)
        XCTAssertEqual(dateActivitiesStarted.count, 1)
        XCTAssertEqual(dateActivitiesEnded.count, 0)
    }

    // MARK: - SaveActivity
    func testCoreDataHaveNoData_WhenSaveActivity_CoreDataHaveOneData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertTrue(saveActivity1)

        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, DiaperState.wet.rawValue)
    }

    func testCoreDataHaveData_WhenSaveActivity_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")
        
        marmotMonitorSaveManager.saveActivity(.diaper(state:.both), 
                                              date: testSecondDateSix,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testSecondDateSix, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 2)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, DiaperState.both.rawValue)
    }

    func testCoreDataHaveData_WhenSaveActivityAtSameDate_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        marmotMonitorSaveManager.saveActivity(.diaper(state:.both), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testThirdDateFive, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let state = (dateActivities.first?.activityArray.first as! Diaper).state
        XCTAssertEqual(state, DiaperState.wet.rawValue)
        XCTAssertEqual(alerteDescription, ActivityType.diaper(state: .wet).alertMessage)
    }

    // MARK: - Activity Type Bottle
    func testCoreDataHaveNoData_WhenSaveActivityOfBottle_CoreDataHaveData() {
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let quantity = (dateActivities.first?.activityArray.first as! Bottle).quantity
        XCTAssertEqual(quantity, 100)
        XCTAssertEqual(alerteDescription, "")
    }

    func testCoreDataHaveData_WhenSaveActivityOfBottle_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 200),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let quantity = (dateActivities.first?.activityArray.first as! Bottle).quantity
        XCTAssertEqual(quantity, 100)
        XCTAssertEqual(alerteDescription, ActivityType.bottle(quantity: 100).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfBottleAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDateSix, to: activityEndDateEight)
        
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
        let breastData = BreastDuration(leftDuration: 120, rightDuration: 120)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastData), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let rightDuration = (dateActivities.first?.activityArray.first as! Breast).rightDuration
        XCTAssertEqual(Int(rightDuration), breastData.rightDuration)
        XCTAssertEqual(alerteDescription, "")
    }

    func testCoreDataHaveData_WhenSaveActivityOfBreast_ShowAlerteAndNotSave() {
        let breastDataFirst = BreastDuration(leftDuration: 120, rightDuration: 120)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastDataFirst), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let breastDataSecond = BreastDuration(leftDuration: 200, rightDuration: 200)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastDataSecond),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let rightDuration = (dateActivities.first?.activityArray.first as! Breast).rightDuration
        XCTAssertEqual(rightDuration, 120)
        XCTAssertEqual(alerteDescription, ActivityType.breast(duration: breastDataFirst).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfBreastAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let breastData = BreastDuration(leftDuration: 120, rightDuration: 120)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastData), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testSecondDateSix, to: activityEndDateEight)
        
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
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 100), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let duration = (dateActivities.first?.activityArray.first as! Sleep).duration
        XCTAssertEqual(duration, 100)
    }

    func testCoreDataHaveData_WhenSaveActivityOfSleep_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 100), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        marmotMonitorSaveManager.saveActivity(.sleep(duration: 200), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let duration = (dateActivities.first?.activityArray.first as! Sleep).duration
        XCTAssertEqual(duration, 100)
        XCTAssertEqual(alerteDescription, ActivityType.sleep(duration: 100).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfSleepAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")
        
        marmotMonitorSaveManager.saveActivity(.sleep(duration: 100),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
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
        let data = GrowthData(weight: 370, height: 52, headCircumference: 26)
        marmotMonitorSaveManager.saveActivity(.growth(data: data), 
                                              date: testFirstDateSeven, 
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let weight = (dateActivities.first?.activityArray.first as! Growth).weight
        XCTAssertEqual(weight, 370)
    }

    func testCoreDataHaveData_WhenSaveActivityOfGrowth_ShowAlerteAndNotSave() {
        let data = GrowthData(weight: 370, height: 52, headCircumference: 26)
        marmotMonitorSaveManager.saveActivity(.growth(data: data), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let data2 = GrowthData(weight: 500, height: 80, headCircumference: 40)
        marmotMonitorSaveManager.saveActivity(.growth(data: data2),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let weight = (dateActivities.first?.activityArray.first as! Growth).weight
        XCTAssertEqual(weight, 370)
        XCTAssertEqual(alerteDescription, ActivityType.growth(data: data).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfGrowthAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let data = GrowthData(weight: 370, height: 52, headCircumference: 26)
        marmotMonitorSaveManager.saveActivity(.growth(data: data), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
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

        marmotMonitorSaveManager.saveActivity(.solid(composition: mockSolidQuantity1), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let vegetable = (dateActivities.first?.activityArray.first as! Solid).vegetable
        XCTAssertEqual(vegetable, 250)
    }

    func testCoreDataHaveData_WhenSaveActivityOfSolid_ShowAlerteAndNotSave() {
        marmotMonitorSaveManager.saveActivity(.solid(composition: mockSolidQuantity1), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        marmotMonitorSaveManager.saveActivity(.solid(composition: mockSolidQuantity2), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)

        let vegetable = (dateActivities.first?.activityArray.first as! Solid).vegetable
        XCTAssertEqual(vegetable, 250)
        XCTAssertEqual(alerteDescription, ActivityType.solid(composition: mockSolidQuantity1).alertMessage)
    }

    func testCoreDataHaveDiaperData_WhenSaveActivityOfSolidAtSameDate_CoreDataHaveTwoData() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        marmotMonitorSaveManager.saveActivity(.solid(composition: mockSolidQuantity1), 
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: testFirstDateSeven, to: activityEndDateEight)
        
        XCTAssertEqual(dateActivities.count, 1)
        XCTAssertEqual(dateActivities[0].activityArray.count, 2)
        

        if let solid = dateActivities.first?.activityArray.first(where: { $0 is Solid }) as? Solid {
            XCTAssertEqual(solid.vegetable, 250)
        } else {
            XCTFail("solid non trouvé")
        }
    }

    // MARK: - Fetch Last Activity
    func testCoreDataHaveDiaperData_WhenFetchLastActivity_ResultHaveActivity() {
        marmotMonitorSaveManager.saveActivity(.diaper(state: .wet),
                                              date: testSecondDateSix,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        marmotMonitorSaveManager.saveActivity(.diaper(state: .dirty),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        marmotMonitorSaveManager.saveActivity(.diaper(state: .both),
                                              date: testThirdDateFive,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        
        let dateActivities = marmotMonitorSaveManager.fetchFirstActivity(ofType: Diaper.self)
        let date = dateActivities?.date.toStringWithTimeAndDayMonthYear()
        let status = dateActivities?.activity.state
        
        XCTAssertEqual(date, "07/01/2024 22:30")
        XCTAssertEqual(status, "Souillée")
    }

    func testCoreDataHaveBottleData_WhenFetchLastActivity_ResultHaveActivity() {
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100),
                                              date: testSecondDateSix,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 150),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        marmotMonitorSaveManager.saveActivity(.diaper(state: .both),
                                              date: testThirdDateFive,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        
        let dateActivities = marmotMonitorSaveManager.fetchFirstActivity(ofType: Bottle.self)
        let date = dateActivities?.date.toStringWithTimeAndDayMonthYear()
        let quantity = dateActivities?.activity.quantity
        
        XCTAssertEqual(date, "07/01/2024 22:30")
        XCTAssertEqual(quantity, 150)
    }

    func testCoreDataHaveBreastData_WhenFetchLastActivity_ResultHaveActivity() {
        let breastDataSecond = BreastDuration(leftDuration: 200, rightDuration: 200)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastDataSecond),
                                              date: testSecondDateSix,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        let breastDataFirst = BreastDuration(leftDuration: 150, rightDuration: 150)
        marmotMonitorSaveManager.saveActivity(.breast(duration: breastDataFirst),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        marmotMonitorSaveManager.saveActivity(.diaper(state: .both),
                                              date: testThirdDateFive,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        
        let dateActivities = marmotMonitorSaveManager.fetchFirstActivity(ofType: Breast.self)
        let date = dateActivities?.date.toStringWithTimeAndDayMonthYear()
        let duration = dateActivities?.activity.rightDuration
        
        XCTAssertEqual(date, "07/01/2024 22:30")
        XCTAssertEqual(duration, 150)
    }

    func testCoreDataHaveSolidData_WhenFetchLastActivity_ResultHaveActivity() {
        marmotMonitorSaveManager.saveActivity(.solid(composition: mockSolidQuantity1),
                                              date: testSecondDateSix,
                                              onSuccess: { saveActivity1 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        
        marmotMonitorSaveManager.saveActivity(.diaper(state: .both),
                                              date: testThirdDateFive,
                                              onSuccess: { saveActivity2 = true},
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        
        let dateActivities = marmotMonitorSaveManager.fetchFirstActivity(ofType: Solid.self)
        let date = dateActivities?.date.toStringWithTimeAndDayMonthYear()
        let total = dateActivities?.activity.total
        
        XCTAssertEqual(date, "06/01/2023 00:00")
        XCTAssertEqual(total, 1500)
    }
}
