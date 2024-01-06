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
    var gender: Gender!

    override func setUp() {
        super.setUp()
        viewModel = GenderViewModel(delegate: self)
    }

    override func tearDown() {
        gender = nil
        super.tearDown()
    }

    func testBabyHaveBoyGender_WhenTappedButton_GenderBoyIsShow() {
        viewModel.buttonTappedWithGender(.boy)

        XCTAssertEqual(gender, .boy)
    }

    func testBabyHaveGirlGender_WhenTappedButton_GenderGirlIsShow() {
        viewModel.buttonTappedWithGender(.girl)

        XCTAssertEqual(gender, .girl)
    }

    func testBabyHaveGirlGender_WhenClearGender_GenderIsNil() {
        viewModel.buttonTappedWithGender(.girl)
        viewModel.buttonTappedWithGender(.none)

        XCTAssertEqual(gender, Gender.none)
    }
}

extension GenderViewModelTest: GenderDelegate {
    func showGender(_ gender: MarmotMonitor.Gender) {
        self.gender = gender
    }
}
