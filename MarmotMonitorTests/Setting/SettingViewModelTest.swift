//
//  SettingViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 19/02/2024.
//

import XCTest
@testable import MarmotMonitor

final class SettingViewModelTest: TestCase {
    private var viewModel: SettingViewModel!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

    // MARK: - test Update info
    func testUserHaveData_WhenRequestBabyName_ReceiveData() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        viewModel = SettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby, iconName: "testIcone", graphType: .ligne, appTheme: 1))
        
        let birthDay = "Né le: " + date

        XCTAssertEqual("Bébé", viewModel.babyName)
        XCTAssertEqual("Fille de Pierrick", viewModel.parentName)
        XCTAssertEqual(birthDay, viewModel.birthDay)
        XCTAssertEqual(GraphType.ligne , viewModel.graphType)
        XCTAssertEqual("testIconeImage" , viewModel.iconImageName)
        XCTAssertEqual("Clair" , viewModel.apparenceStyle)
    }

    func testUserHaveNoData_WhenRequestBabyName_ReceiveDefaultData() {
        
        let baby = Person(name: nil, gender: nil, parentName: nil, birthDay: nil )
        viewModel = SettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        XCTAssertEqual("", viewModel.babyName)
        XCTAssertEqual("", viewModel.parentName)
        XCTAssertEqual("", viewModel.birthDay)
        XCTAssertEqual(GraphType.round , viewModel.graphType)
        XCTAssertEqual("AppIconImage" , viewModel.iconImageName)
        XCTAssertEqual("Auto" , viewModel.apparenceStyle)
    }
    

    // MARK: - test parent
    
    func testUserHaveBoy_WhenRequestParent_ReceiveData() {
        
        let baby = Person(name: nil, gender: .boy, parentName: "test", birthDay: nil )
        viewModel = SettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

 
        XCTAssertEqual("Fils de test", viewModel.parentName)
    }

    func testUserHaveGirl_WhenRequestParent_ReceiveData() {
        
        let baby = Person(name: nil, gender: .girl, parentName: "test", birthDay: nil )
        viewModel = SettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

 
        XCTAssertEqual("Fille de test", viewModel.parentName)
    }
    
    func testUserHaveNoGender_WhenRequestParent_ReceiveData() {
        
        let baby = Person(name: nil, gender: nil, parentName: "test", birthDay: nil )
        viewModel = SettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

 
        XCTAssertEqual("Parent: test", viewModel.parentName)
    }

    //MARK: - test darkMode
    func testUserSetDarkMode_WhenRequestApparence_ReceiveDark() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        viewModel = SettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby, iconName: "testIcone", graphType: .ligne, appTheme: 2))
        
        XCTAssertEqual("Sombre" , viewModel.apparenceStyle)
    }
    
}
