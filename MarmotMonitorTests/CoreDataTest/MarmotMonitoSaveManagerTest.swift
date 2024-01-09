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

    func testCoreDataHaveBottle_WhenCallFethBottle_ReturnArrayOfBottle() {
        let date = Date()
        marmotMonitorSaveManager.saveBottle(100, date: date)

        let result = marmotMonitorSaveManager.fetchDiapers()

        XCTAssertEqual(result[0].state, "Urine")
    }

}

