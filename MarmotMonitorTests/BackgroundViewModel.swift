//
//  BackgroundViewModel.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 10/12/2023.
//

import XCTest

@testable import MarmotMonitor

class BackgroundViewModelTest: XCTestCase{

    var viewModel: BackgroundViewModel!
    var babyNameViewModel: BabyNameViewModel!
    var genderViewModel: GenderViewModel!
    var parentViewModel: ParentNameViewModel!
    var birthDayViewModel: BirthDayViewModel!
    var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = BackgroundViewModel(defaults: defaults)
        genderViewModel = GenderViewModel(defaults: defaults, delegate: self)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testBabyHaveGender_WhenSetRequestGender_receiveGender() {
        genderViewModel.buttonTappedWithGender(.girl)
        genderViewModel.saveGender()

        let gender = viewModel.getGender()

        XCTAssertEqual(gender, "Fille")
    }

    func testBabyHaveNoGender_WhenSetRequestGender_receiveNil() {
        genderViewModel.buttonTappedWithGender(.none)
        genderViewModel.saveGender()
        let gender = viewModel.getGender()

        XCTAssertEqual(gender, nil)
    }
}

extension BackgroundViewModelTest: GenderDelegate {
    func didChangeGender() {
        genderViewModel.saveGender()
    }

    func showGender(_ gender: MarmotMonitor.Gender) {
    }
}
