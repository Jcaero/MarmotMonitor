//
//  TodayViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 04/12/2023.
//

import XCTest

@testable import MarmotMonitor

class TodayViewModelTest: TestCase {
    private var viewModel: TodayViewModel!
    private var coreDatatManager: MarmotMonitorSaveManager!
    
    private var saveActivity1 = false
    private var alerteDescription = ""

    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = TodayViewModel(marmotMonitorSaveManager: coreDatatManager)
        
        saveActivity1 = false
        alerteDescription = ""
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }

    func saveData(person: Person) {
        
    }

    // MARK: - test userdefault
    func testUserDefaultHaveData_WhenRequestLabelText_receiveLabeltexte() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Fille", parentName: "Pierrick", birthDay: date )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let texte = viewModel.welcomeTexte()

        XCTAssertEqual(texte, "Bonjour Pierrick et Bébé")
    }

    func testUserDefaultHaveJusteBabyData_WhenRequestLabelText_receiveLabeltexte() {
        let baby = Person(name: "Bébé")
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let texte = viewModel.welcomeTexte()

        XCTAssertEqual(texte, "Bonjour Bébé")
    }

    func testBabyBornToday_WhenRequestAge_receiveAgeForText() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Fille", parentName: "Pierrick", birthDay: date )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let year = viewModel.babyYear()
        let month = viewModel.babyMonth()

        XCTAssertEqual(year, "0")
        XCTAssertEqual(month, "0")
    }

    func testBabyBorn2MonthAgo_WhenRequestAge_receiveAgeForText() {
        let date = Date()
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: -2, to: date)
        let babyDate = newDate!.toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Fille", parentName: "Pierrick", birthDay: babyDate )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let year = viewModel.babyYear()
        let month = viewModel.babyMonth()

        XCTAssertEqual(year, "0")
        XCTAssertEqual(month, "2")
    }

    func testBabyBorn3YearAnd2MonthAgo_WhenRequestAge_receiveAgeForText() {
        let date = Date()
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .year, value: -3, to: date)
        let newDate2 = calendar.date(byAdding: .month, value: -2, to: newDate!)
        let babyDate = newDate2!.toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Fille", parentName: "Pierrick", birthDay: babyDate )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let year = viewModel.babyYear()
        let month = viewModel.babyMonth()

        XCTAssertEqual(year, "3")
        XCTAssertEqual(month, "2")
    }

    func testBabyHaveNoBirthDay_WhenRequestAge_receiveNil() {
        let baby = Person(name: "Bébé")
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let year = viewModel.babyYear()
        let month = viewModel.babyMonth()

        XCTAssertEqual(year, "")
        XCTAssertEqual(month, "")
    }

    // MARK: - Test coreData
    func testCoreDataHaveData_WhenFetchData_TableViewIsUpdate(){
        coreDatatManager.saveActivity(.diaper(state: .wet),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[2].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[2].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir la couche")
        XCTAssertEqual(activityTitleAfter, "07/01/2024 22:30 Urine")
    }

    func testCoreDataHaveNoData_WhenFetchData_TableViewIsUpdate(){
        let activityTitle = viewModel.activities[2].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[2].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir la couche")
        XCTAssertEqual(activityTitleAfter, "Saisir la couche")
    }
}
