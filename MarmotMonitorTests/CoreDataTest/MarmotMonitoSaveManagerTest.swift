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
        marmotMonitorSaveManager = nil
    }

    func testCoreDataHaveDiaper_WhenCallFethDiaper_ReturnArrayOfDiaper() {
        let date = Date()
        marmotMonitorSaveManager.saveDiaper("Urine", date: date)

        let result = marmotMonitorSaveManager.fetchDiapers()

        XCTAssertEqual(result[0].state, "Urine")
    }

    func testCoreData() {
        let testFirstDate = "07/01/2024".toDate()
        let testSecondDate = "06/01/2023".toDate()
        let testThirdDate = "05/01/2024".toDate()
    
        marmotMonitorSaveManager.saveDiaper("Urine", date: testFirstDate!)
        marmotMonitorSaveManager.saveDiaper("Mixte", date: testSecondDate!)
        marmotMonitorSaveManager.saveBottle(100, date: testFirstDate!)
        marmotMonitorSaveManager.saveDate(date: testThirdDate!)

        let dateActivities = marmotMonitorSaveManager.fetchDateActivities()
        let diapers = dateActivities.filter { $0.activityArray.contains(where: { $0 is Diaper }) }
        
//        let result = marmotMonitorSaveManager.fetchDiapers()
//        let result = marmotMonitorSaveManager.testDiaperFetch()
        
        print ("dateActivities = \(dateActivities.count)")
        print ("diapers = \(diapers.count)")
        print ("\(String(describing: dateActivities[0].date))")
//        XCTAssertEqual(result[0].state, "Mixte")
    }


    func testCoreDataHaveBottle_WhenCallFethBottle_ReturnArrayOfBottle() {
        let date = Date()
        marmotMonitorSaveManager.saveBottle(100, date: date)

        let result = marmotMonitorSaveManager.fetchDiapers()

        XCTAssertEqual(result[0].state, "Urine")
    }

}

