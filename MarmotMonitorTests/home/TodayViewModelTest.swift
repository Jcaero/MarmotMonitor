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
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
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
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let first = viewModel.babyFirstElement()
        let second = viewModel.babySecondElement()

        XCTAssertEqual(first, "")
        XCTAssertEqual(second, "0\njours")
    }

    func testBabyBorn2MonthAgo_WhenRequestAge_receiveAgeForText() {
        let date = Date()
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: -2, to: date)
        let babyDate = newDate!.toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: babyDate )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let first = viewModel.babyFirstElement()
        let second = viewModel.babySecondElement()

        XCTAssertEqual(first, "2\nmois")
        XCTAssertEqual(second, "0\njours")
    }

    func testBabyBorn3YearAnd2MonthAgo_WhenRequestAge_receiveAgeForText() {
        // Utiliser directement la date actuelle sans conversion inutile
           let date = Date()

           var calendar = Calendar.current
           calendar.timeZone = TimeZone(identifier: "Europe/Paris")!

           let newDate = calendar.date(byAdding: .year, value: -3, to: date)
           let newDate2 = calendar.date(byAdding: .month, value: -2, to: newDate!)
           let babyDate = newDate2!.toStringWithDayMonthYear()

           // Création du bébé et du viewModel
           let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: babyDate)
           let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

           // Récupération et test des éléments
           let first = viewModel.babyFirstElement()
           let second = viewModel.babySecondElement()

           XCTAssertEqual(first, "3\nans")
           XCTAssertEqual(second, "2\nmois")
    }

    func testBabyBorn3MonthAnd2dayAgo_WhenRequestAge_receiveAgeForText() {
        let date = Date()
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: -1, to: date)
        let newDate2 = calendar.date(byAdding: .day, value: -2, to: newDate!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier:"GMT")!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let babyDate = dateFormatter.string(from: newDate2!)
        
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: babyDate )
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let first = viewModel.babyFirstElement()
        let second = viewModel.babySecondElement()

        XCTAssertEqual(first, "1\nmois")
        XCTAssertEqual(second, "2\njours")
    }

    func testBabyHaveNoBirthDay_WhenRequestAge_receiveNil() {
        let baby = Person(name: "Bébé")
        let viewModel = TodayViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let first = viewModel.babyFirstElement()
        let second = viewModel.babySecondElement()

        XCTAssertEqual(first, "")
        XCTAssertEqual(second, "")
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
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) Urine")
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
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) biberon de 100 ml")
    }

    func testCoreDataHaveManyData_WhenFetchBottleData_TableViewIsUpdate(){
        coreDatatManager.saveActivity(.bottle(quantity: 100),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        coreDatatManager.saveActivity(.bottle(quantity: 200),
                                              date: testSecondDateSix,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})

        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[0].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[0].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir la tétée/le biberon")
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) biberon de 100 ml")
    }

    func testCoreDataHaveData_WhenFetchBreastData_TableViewIsUpdate(){
        coreDatatManager.saveActivity(.breast(duration: BreastDuration(leftDuration: 500, rightDuration: 500)),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[0].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[0].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir la tétée/le biberon")
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) tétée de 16 min")
    }

    func testCoreDataHaveData_WhenFetchSolidData_TableViewIsUpdate(){
        coreDatatManager.saveActivity(.solid(composition: mockSolidQuantity1),
                                              date: testFirstDateSeven,
                                              onSuccess: { saveActivity1 = true} ,
                                              onError: {alerteMessage in alerteDescription = alerteMessage})
        XCTAssertEqual(alerteDescription, "")

        let activityTitle = viewModel.activities[0].cellSubTitle
        viewModel.fetchLastActivities()
        
        let activityTitleAfter = viewModel.activities[0].cellSubTitle
        
        XCTAssertEqual(activityTitle, "Saisir la tétée/le biberon")
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) aliments: 1500 g")
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
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) 01 H")
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
        XCTAssertEqual(activityTitleAfter, "\(testFirstDateSeven.toStringWithTimeAndDayMonthYear()) Taille: 51.3 cm Poids: 25.0 Kg")
    }

    // MARK: - Test Convert Format accessibility
    func testTitleHaveTexteMonth_WhenConvertData_DataIsConvert(){
        let title = "2 mois"

        let newTitle = viewModel.convertAgeFormatAccessibility(originalText: title)
        
        XCTAssertEqual(newTitle, "2 M")
    }

    func testTitleHaveTexteYear_WhenConvertData_DataIsConvert(){
        let title = "2 ans"

        let newTitle = viewModel.convertAgeFormatAccessibility(originalText: title)
        
        XCTAssertEqual(newTitle, "2 A")
    }

    func testTitleHaveTexteDay_WhenConvertData_DataIsConvert(){
        let title = "2 jours"

        let newTitle = viewModel.convertAgeFormatAccessibility(originalText: title)
        
        XCTAssertEqual(newTitle, "2 J")
    }

    // MARK: - Test Convert Format Normal
    func testTitleHaveTexteMonth_WhenConvertDataNormaly_DataIsConvert(){
        let title = "2M"

        let newTitle = viewModel.convertAgeFormatNormal(originalText: title)
        
        XCTAssertEqual(newTitle, "2\nmois")
    }

    func testTitleHaveTexteYear_WhenConvertDataNormaly_DataIsConvert(){
        let title = "2A"

        let newTitle = viewModel.convertAgeFormatNormal(originalText: title)
        
        XCTAssertEqual(newTitle, "2\nans")
    }

    func testTitleHaveTexteDay_WhenConvertDataNormaly_DataIsConvert(){
        let title = "2J"

        let newTitle = viewModel.convertAgeFormatNormal(originalText: title)
        
        XCTAssertEqual(newTitle, "2\njours")
    }
    
}
