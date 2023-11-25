//
//  BabyNameViewControllerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 25/11/2023.
//

import XCTest
@testable import MarmotMonitor

class BabyNameViewModelTests: XCTestCase {
    var viewModel: BabyNameViewModel!
    var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = BabyNameViewModel(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testBabyHaveName_WhenSaveBabyName_NameHasBeenSave() {
        let testBabyName = "Test Name"

        viewModel.saveBabyName(name: testBabyName)

        let savedName = defaults.string(forKey: UserInfoKey.babyName.rawValue)
        XCTAssertEqual(savedName, testBabyName)
    }

    func testBabyHaveNoName_WhenSaveBabyName_NoNameHasBeenSave() {
        let testBabyName = ""

        viewModel.saveBabyName(name: testBabyName)

        let savedName = defaults.string(forKey: UserInfoKey.babyName.rawValue)
        XCTAssertEqual(savedName, testBabyName)
    }
}
