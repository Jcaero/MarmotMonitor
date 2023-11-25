//
//  ParentNameViewController.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 25/11/2023.
//

import XCTest
@testable import MarmotMonitor

class ParentNameViewModelTest: XCTestCase {
    var viewModel: ParentNameViewModel!
    var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        viewModel = ParentNameViewModel(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testParentHaveName_WhenSaveParent_ParentNameIsSave() {
        let parentName = "Test Name"
        viewModel.saveParentName(name: parentName)

        let savedGender = defaults.string(forKey: UserInfoKey.parentName.rawValue)
        XCTAssertEqual(savedGender, parentName)
    }

    func testParentHaveNoName_WhenSaveParent_ParentNameIsNil() {
        let parentName = ""
        viewModel.saveParentName(name: parentName)

        let savedGender = defaults.string(forKey: UserInfoKey.parentName.rawValue)
        XCTAssertEqual(savedGender, nil)
    }
}
