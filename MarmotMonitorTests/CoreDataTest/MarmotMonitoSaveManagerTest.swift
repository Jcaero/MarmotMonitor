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

    func testCoreData() {
        let testFirstDate = "07/01/2024".toDate()
        let testSecondDate = "06/01/2023".toDate()
        let testThirdDate = "05/01/2024".toDate()
    
        marmotMonitorSaveManager.saveActivity(.diaper(state: "Urine"), date: testFirstDate!)
        marmotMonitorSaveManager.saveActivity(.diaper(state: "Mixte"), date: testThirdDate!)
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), date: testFirstDate!)
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

    func testCoreDataAvecDate() {
        let testFirstDate = "07/01/2024 22:30".toDateWithTime()
        let testSecondDate = "06/01/2023".toDate()
        let testThirdDate = "05/01/2024".toDate()
        let activityEndDate = "08/01/2024".toDate()
        let activityStartDate = "06/01/2024".toDate()
    
        marmotMonitorSaveManager.saveActivity(.diaper(state: "Urine"), date: testFirstDate!)
        marmotMonitorSaveManager.saveActivity(.diaper(state: "Mixte"), date: testThirdDate!)
        marmotMonitorSaveManager.saveActivity(.bottle(quantity: 100), date: testFirstDate!)
        marmotMonitorSaveManager.saveDate(date: testThirdDate!)

        let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: activityStartDate!, to: activityEndDate!)
        print ("dateActivities activityArray = \(dateActivities[0].activityArray.count)")
        let diapers = dateActivities.filter { $0.activityArray.contains(where: { $0 is Diaper }) }

        print ("dateActivities = \(dateActivities.count)")
        print ("diapers = \(diapers.count)")
        print ("\(String(describing: dateActivities[0].date))")
    }
}

