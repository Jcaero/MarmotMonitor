//
//  TodayViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 04/12/2023.
//

import XCTest

@testable import MarmotMonitor

class TodayViewModelTest: XCTestCase, BirthDayDelegate {
    var viewModel: TodayViewModel!
    var babyNameViewModel: BabyNameViewModel!
    var genderViewModel: GenderViewModel!
    var parentViewModel: ParentNameViewModel!
    var birthDayViewModel: BirthDayViewModel!
    var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = TodayViewModel(defaults: defaults)
        babyNameViewModel = BabyNameViewModel(defaults: defaults)
        genderViewModel = GenderViewModel(defaults: defaults)
        parentViewModel = ParentNameViewModel(defaults: defaults)
        birthDayViewModel = BirthDayViewModel(defaults: defaults, delegate: self)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func saveData(person: Person) {
        babyNameViewModel.saveBabyName(name: person.name)

        switch person.gender {
        case "Garçon" :
            genderViewModel.setBoyGender()
        case "Fille":
            genderViewModel.setGirlGender()
        default: break
        }
        genderViewModel.saveGender()

        if let parentName = person.parentName {
            parentViewModel.saveParentName(name: parentName)
        }

        if let date = person.birthDay {
            birthDayViewModel.saveBirthDate(stringDate: date)
        }
    }

    func testUserDefaultHaveBoyData_WhenRequestDate_sendData() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Garçon", parentName: "Pierrick", birthDay: date )
        saveData(person: baby)

        let person = viewModel.requestPersonData()

        XCTAssertEqual(person!.name, baby.name)
        XCTAssertEqual(person!.gender, baby.gender)
        XCTAssertEqual(person!.parentName, baby.parentName)
        XCTAssertEqual(person!.birthDay, baby.birthDay)
    }

    func testUserDefaultHaveGirlData_WhenRequestDate_sendData() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Fille", parentName: "Pierrick", birthDay: date )
        saveData(person: baby)

        let person = viewModel.requestPersonData()

        XCTAssertEqual(person!.name, baby.name)
        XCTAssertEqual(person!.gender, baby.gender)
        XCTAssertEqual(person!.parentName, baby.parentName)
        XCTAssertEqual(person!.birthDay, baby.birthDay)
    }

    func testUserDefaultHaveNoData_WhenRequestDate_sendNil() {
        let person = viewModel.requestPersonData()

        XCTAssertNil(person)
    }

    func testUserDefaultHaveNoFullData_WhenRequestDate_sendData() {
        let baby = Person(name: "Bébé")
        saveData(person: baby)

        let person = viewModel.requestPersonData()

        XCTAssertEqual(person!.name, baby.name)
        XCTAssertNil(person?.gender)
        XCTAssertNil(person?.parentName)
        XCTAssertNil(person?.birthDay)
    }
}

extension TodayViewModelTest {
    func showAlert(title: String, description: String) {
    }

    func pushToNextView() {
    }
}
