//
//  UserDefaultsManager.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 25/11/2023.
//

import XCTest
@testable import MarmotMonitor

class UserDefaultsManagerTests: XCTestCase {
    var userDefaultsManager: UserDefaultsManager!
    var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        userDefaultsManager = UserDefaultsManager(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testBabyHaveName_WhenSaveBabyName_NameHasBeenSave() {
        let testBabyName = "Test"

        userDefaultsManager.saveBabyName(testBabyName)

        let savedName = defaults.string(forKey: UserInfoKey.babyName.rawValue)
        XCTAssertEqual(savedName, testBabyName)
    }

    func testBabyHaveNoName_WhenSaveBabyName_NoNameHasBeenSave() {
        let testBabyName = ""

        userDefaultsManager.saveBabyName(testBabyName)

        let savedName = defaults.string(forKey: UserInfoKey.babyName.rawValue)
        XCTAssertEqual(savedName, nil)
    }

    func testBabyHaveNameWithCapitalized_WhenSaveBabyName_NameHasBeenSave() {
        let testBabyName = "TeSt"

        userDefaultsManager.saveBabyName(testBabyName)

        let savedName = defaults.string(forKey: UserInfoKey.babyName.rawValue)
        XCTAssertEqual(savedName, "Test")
    }

    // MARK: - Gender
    func testBabyHaveNoGender_WhenSaveGender_NoGenderSave() {

        userDefaultsManager.saveGender(.none)

        let savedGender = userDefaultsManager.getGender()
        XCTAssertEqual(savedGender, nil)
    }

    func testBabyHaveBoyGender_WhenSaveGender_GenderSaveIsBoy() {

        userDefaultsManager.saveGender(.boy)

        let savedGender = userDefaultsManager.getGender()
        XCTAssertEqual(savedGender, "Garçon")
    }

    func testBabyHaveGirlGender_WhenSaveGender_GenderSaveIsGirl() {

        userDefaultsManager.saveGender(.girl)

        let savedGender = userDefaultsManager.getGender()
        XCTAssertEqual(savedGender, "Fille")
    }

    // MARK: - Parent Name
    func testParentHaveName_WhenSaveParent_ParentNameIsSave() {
        let parentName = "Test"
        userDefaultsManager.saveParentName(parentName)

        let savedGender = defaults.string(forKey: UserInfoKey.parentName.rawValue)
        XCTAssertEqual(savedGender, parentName)
    }

    func testParentHaveNameWithCapitalized_WhenSaveParent_ParentNameIsSave() {
        let parentName = "TeSt"
        userDefaultsManager.saveParentName(parentName)

        let savedGender = defaults.string(forKey: UserInfoKey.parentName.rawValue)
        XCTAssertEqual(savedGender, "Test")
    }

    func testParentHaveNoName_WhenSaveParent_ParentNameIsNil() {
        let parentName = ""
        userDefaultsManager.saveParentName(parentName)

        let savedGender = defaults.string(forKey: UserInfoKey.parentName.rawValue)
        XCTAssertEqual(savedGender, nil)
    }

    func testParentIsNil_WhenSaveParent_ParentNameIsNil() {
        userDefaultsManager.saveParentName(nil)

        let savedGender = defaults.string(forKey: UserInfoKey.parentName.rawValue)
        XCTAssertEqual(savedGender, nil)
    }

    // MARK: - BirthDay
    func testBabyHaveDate_WhenSaveBabyDate_DateHasBeenSave() {
        let testBabyDate = "25/11/2023"

        userDefaultsManager.saveDateOfBirth(testBabyDate)

        let savedName = defaults.string(forKey: UserInfoKey.birthDay.rawValue)
        XCTAssertEqual(savedName, testBabyDate)
    }

    func testBabyHaveNoDate_WhenSaveBabyDate_NoDateHasBeenSave() {
        let testBabyDate = ""

        userDefaultsManager.saveDateOfBirth(testBabyDate)

        let savedName = defaults.string(forKey: UserInfoKey.birthDay.rawValue)
        XCTAssertEqual(savedName, nil)
    }

    func testBabyHaveNoData_WhenSaveBabyDate_NoDateHasBeenSave() {

        userDefaultsManager.saveDateOfBirth(nil)

        let savedName = defaults.string(forKey: UserInfoKey.birthDay.rawValue)
        XCTAssertEqual(savedName, nil)
    }
}
