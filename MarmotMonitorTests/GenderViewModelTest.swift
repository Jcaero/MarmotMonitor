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

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = GenderViewModel(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testBabyHaveNoGender_WhenSaveGender_NoGenderSave() {

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: "gender")
        XCTAssertEqual(savedGender, nil)
    }

    func testBabyHaveBoyGender_WhenSaveGender_GenderSavedIsBoy() {
        let testGender = "Garçon"
        viewModel.setBoyGender()

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: "gender")
        XCTAssertEqual(savedGender, testGender)
    }

    func testBabyHaveGirlGender_WhenSaveGender_GenderSavedIsGirl() {
        let testGender = "Fille"
        viewModel.setGirlGender()

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: "gender")
        XCTAssertEqual(savedGender, testGender)
    }

    func testBabyHaveGirlGender_WhenClearGenderAndSave_GenderIsNil() {
        viewModel.setGirlGender()
        viewModel.clearGender()

        viewModel.saveGender()

        let savedGender = defaults.string(forKey: "gender")
        XCTAssertEqual(savedGender, nil)
    }
}
