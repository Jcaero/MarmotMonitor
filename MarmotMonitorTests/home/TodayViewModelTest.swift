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
    func testCoreDataHaveNoData_WhenFetchData_TableViewIsUpdate(){
        viewModel.fetchLastActivities()
        
        let activityMeal = viewModel.activities[0].cellSubTitle
        let activitySleep = viewModel.activities[1].cellSubTitle
        let activityDiaper = viewModel.activities[2].cellSubTitle
        let activityGrowth = viewModel.activities[3].cellSubTitle
        
        XCTAssertEqual(activityMeal, "Saisir la tétée/le biberon")
        XCTAssertEqual(activitySleep, "Saisir le sommeil")
        XCTAssertEqual(activityDiaper, "Saisir la couche")
        XCTAssertEqual(activityGrowth, "Ajouter une mesure")
    }

    func testCoreDataHaveData_WhenFetchDiaperData_TableViewIsUpdate(){
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

    func testCoreDataHaveData_WhenFetchBottleData_TableViewIsUpdate(){
        coreDatatManager.saveActivity(.bottle(quantity: 100),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[0].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[0].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir la tétée/le biberon")
        XCTAssertEqual(activityTitleAfter, "07/01/2024 22:30 biberon de 100 ml")
    }

    func testCoreDataHaveData_WhenFetchSleepData_TableViewIsUpdate(){
        coreDatatManager.saveActivity(.sleep(duration: 3600),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[1].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[1].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir le sommeil")
        XCTAssertEqual(activityTitleAfter, "07/01/2024 22:30 01 H")
    }

    func testCoreDataHaveData_WhenFetchGrowthData_TableViewIsUpdate(){
        let data = GrowthData(weight: 25.0, height: 51.3, headCircumference: 0.0)
        coreDatatManager.saveActivity(.growth(data: data),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[3].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[3].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Ajouter une mesure")
        XCTAssertEqual(activityTitleAfter, "07/01/2024 22:30 Taille: 51.3 cm Poids: 25.0 Kg")
    }
}
