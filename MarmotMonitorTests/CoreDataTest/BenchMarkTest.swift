//
//  BenchMarkTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 13/01/2024.
//
import XCTest
@testable import MarmotMonitor

final class BenchMarkTest: TestCase {

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

    func testBenchmarkFetchSaveActivity() {
        let calendar = Calendar.current
        for i in 0..<1000 {
            // Créer une nouvelle date pour chaque itération
            if let newDate = calendar.date(byAdding: .day, value: -i, to: Date()) {
                marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: newDate)
            }
        }

        measure {
            let StartDate = calendar.date(byAdding: .day, value: -1000, to: Date())
            let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: StartDate!, to: Date())
            XCTAssertEqual(dateActivities.count, 1000)
        }
    }

    func testBenchmarkSaveActivity() {
        measure {
            let calendar = Calendar.current
            for i in 0..<1000 {
                // Créer une nouvelle date pour chaque itération
                if let newDate = calendar.date(byAdding: .day, value: -i, to: Date()) {
                    marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: newDate)
                }
            }
        }
    }

    func testBenchmarkSaveOneActivity() {
        measure {
            marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: Date())
        }
    }
}

extension BenchMarkTest: MarmotMonitorSaveManagerDelegate {
    func showAlert(title: String, description: String) {
    }
}
    
