//
//  TodayViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 04/12/2023.
//

import XCTest

@testable import MarmotMonitor

class TodayViewModelTest: XCTestCase {
    var viewModel: TodayViewModel!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func saveData(person: Person) {
        
    }

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
}
