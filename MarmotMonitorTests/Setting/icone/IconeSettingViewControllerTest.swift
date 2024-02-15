//
//  IconeSettingViewControllerTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 15/02/2024.
//

import XCTest
@testable import MarmotMonitor

final class IconeSettingViewControllerTest: TestCase {
    
    private var viewModel: ApparenceSettingViewModel!
    
    private var isSave: Bool!
    
    override func setUp() {
        super.setUp()
        viewModel = ApparenceSettingViewModel()
        
        isSave = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

    // MARK: - test Gender
    func testUserDefaultHaveData_WhenRequestColor_receiveGenderGirl() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = IconSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let gender = viewModel.gender
        
        XCTAssertEqual(gender, "Fille")
    }

    // MARK: - test color
    func testUserDefaultHaveData_WhenRequestGender_receiveGenderBoy() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .boy, parentName: "Pierrick", birthDay: date )
        let viewModel = IconSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let gender = viewModel.gender
        
        XCTAssertEqual(gender, "Garçon")

    }

    func testUserDefaultHaveNoData_WhenRequestGender_receiveGender() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: Gender.none, parentName: "Pierrick", birthDay: date )
        let viewModel = IconSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let gender = viewModel.gender

        XCTAssertEqual(gender, "")
    }

    func testUserDefaultHaveIcone_WhenRequestIconeName_receiveImageName() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: Gender.none, parentName: "Pierrick", birthDay: date )
        let viewModel = IconSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let oldName = viewModel.getIconeImageName()

        viewModel.saveIconeName(name: "IconeBleu")

        let newName = viewModel.getIconeImageName()

        XCTAssertNotEqual(newName, oldName)
        XCTAssertEqual(newName, "IconeBleuImage")
    }

    func testNoIcone_WhenSetIconeName_saveImageName() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: Gender.none, parentName: "Pierrick", birthDay: date )
        let viewModel = IconSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby, iconName: ""))

        let oldName = viewModel.iconeName

        viewModel.setIconeName(name: "test")

        let newName = viewModel.iconeName

        XCTAssertNotEqual(newName, oldName)
        XCTAssertEqual(newName, "test")
    }
    
    

}
