//
//  BenchMarkTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 13/01/2024.
//
import XCTest
@testable import MarmotMonitor

final class BenchMarkTest: TestCase {
//
//    var marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol!
//    var todayViewModel: TodayViewModel!
//    
//    var alerteTitle = ""
//    var alerteDescription = ""
//    
//    override func setUpWithError() throws {
//        marmotMonitorSaveManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
//    }
//    
//    override func tearDownWithError() throws {
//        marmotMonitorSaveManager.clearDatabase()
//        marmotMonitorSaveManager = nil
//        alerteTitle = ""
//        alerteDescription = ""
//    }
//
//    func testBenchmarkFetchSaveActivity() {
//        let calendar = Calendar.current
//        for i in 0..<1000 {
//            // Créer une nouvelle date pour chaque itération
//            if let newDate = calendar.date(byAdding: .day, value: -i, to: Date()) {
//                marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: newDate, onSuccess: {} , onError: {_ in })
//            }
//        }
//
//        measure {
//            let StartDate = calendar.date(byAdding: .day, value: -1000, to: Date())
//            let dateActivities = marmotMonitorSaveManager.fetchDateActivitiesWithDate(from: StartDate!, to: Date())
//            XCTAssertEqual(dateActivities.count, 1000)
//        }
//    }
//
//    func testBenchmarkSaveOneActivity() {
//        measure {
//            marmotMonitorSaveManager.saveActivity(.diaper(state: .wet), date: Date(), onSuccess: {} , onError: {_ in })
//        }
//    }
//
//    
//    func testBenchmarkFetchTodayActivityWith1000Items() {
//        let calendar = Calendar.current
//        let ActivityType: [ActivityType] = [
//            .diaper(state: .wet),
//            .diaper(state: .dirty),
//            .bottle(quantity: 100),
//            .bottle(quantity: 200),
//            .breast(duration: BreastDuration(leftDuration: 120, rightDuration: 120)),
//            .breast(duration: BreastDuration(leftDuration: 200, rightDuration: 150)),
//            .sleep(duration: 100),
//            .sleep(duration: 300),
//            .growth(data: GrowthData(weight: 370, height: 52, headCircumference: 26)),
//            .growth(data: GrowthData(weight: 400, height: 55, headCircumference: 27)),
//            .solid(composition: SolidQuantity(vegetable: 250,
//                                               meat: 250,
//                                               fruit: 250,
//                                               dairyProduct: 250,
//                                               cereal: 250,
//                                               other: 250)),
//            .solid(composition: SolidQuantity(vegetable: 300,
//                                               meat: 300,
//                                               fruit: 300,
//                                               dairyProduct: 300,
//                                               cereal: 300,
//                                               other: 300))
//        ]
//        
//        
//        for i in 0..<1000 {
//            // Créer une nouvelle date pour chaque itération
//            if let newDate = calendar.date(byAdding: .day, value: -i, to: Date()) {
//                let randomActivity = ActivityType.randomElement()!
//                marmotMonitorSaveManager.saveActivity(randomActivity, date: newDate, onSuccess: {} , onError: {_ in })
//            }
//        }
//
//        measure {
//            todayViewModel = TodayViewModel(marmotMonitorSaveManager: marmotMonitorSaveManager)
//            todayViewModel.fetchLastActivities()
//        }
//    }
}
    
