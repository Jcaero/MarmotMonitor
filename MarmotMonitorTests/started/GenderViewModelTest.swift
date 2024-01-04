//
//  GenderViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 25/11/2023.
//

import XCTest
@testable import MarmotMonitor

class GenderViewModelTest: XCTestCase {
    var viewModel: GenderViewModel!
    var defaults: UserDefaults!
    var gender: Gender!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = GenderViewModel(defaults: defaults, delegate: self)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        gender = nil
        super.tearDown()
    }

    func testBabyHaveNoGender_WhenSaveGender_NoGenderSave() {

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: UserInfoKey.gender.rawValue)
        XCTAssertEqual(savedGender, nil)
    }

    func testBabyHaveBoyGender_WhenSaveGender_GenderSavedIsBoy() {
        let testGender = "Garçon"
        viewModel.buttonTappedWithGender(.boy)

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: UserInfoKey.gender.rawValue)
        XCTAssertEqual(savedGender, testGender)
        XCTAssertEqual(gender, .boy)
    }

    func testBabyHaveGirlGender_WhenSaveGender_GenderSavedIsGirl() {
        let testGender = "Fille"
        viewModel.buttonTappedWithGender(.girl)

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: UserInfoKey.gender.rawValue)
        XCTAssertEqual(savedGender, testGender)
        XCTAssertEqual(gender, .girl)
    }

    func testBabyHaveGirlGender_WhenClearGenderAndSave_GenderIsNil() {
        viewModel.buttonTappedWithGender(.girl)
        viewModel.buttonTappedWithGender(.none)

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: UserInfoKey.gender.rawValue)
        XCTAssertEqual(savedGender, nil)
        XCTAssertEqual(gender, Gender.none)
    }
}

extension GenderViewModelTest: GenderDelegate {
    func showGender(_ gender: MarmotMonitor.Gender) {
        self.gender = gender
    }
}
