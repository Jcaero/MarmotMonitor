//
//  informationViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 17/02/2024.
//

import XCTest
@testable import MarmotMonitor

final class InformationViewModelTest: TestCase {
    private var viewModel: InformationViewModel!
    
    private var isAlerted: Bool!
    
    override func setUp() {
        super.setUp()
        
        isAlerted = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    // MARK: - test Update info
    func testUserDefaultHaveData_WhenRequestInfo_UpdateInfo() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        viewModel = InformationViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.getUserInformation()
        
        XCTAssertEqual("Bébé", viewModel.babyName)
        XCTAssertEqual("Pierrick", viewModel.parentName)
        XCTAssertEqual(date, viewModel.birthDay)
        XCTAssertEqual("Fille", viewModel.gender)
    }

    func testUserDefaultHaveNoData_WhenRequestInfo_UpdateInfo() {
        let baby = Person(name: nil, gender: nil, parentName: nil, birthDay: nil )
        viewModel = InformationViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.getUserInformation()
        
        XCTAssertEqual("Entrer le nom", viewModel.babyName)
        XCTAssertEqual("Entrer le nom du parent", viewModel.parentName)
        XCTAssertEqual("JJ/MM/YYYY", viewModel.birthDay)
        XCTAssertEqual("", viewModel.gender)
    }

    // MARK: - test save info alerte
    func testSaveInfo_WhenBabyNameIsInvalid_ShowAlert() {
        let baby = Person(name: "T", gender: Gender.none, parentName: nil, birthDay: nil )
        viewModel = InformationViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.saveUserInformation(person: baby) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.isAlerted = true
                XCTAssertEqual(.invalideNameLength, error)
            }
        }
    }

    func testSaveInfo_WhenBabyBirthDayIsInvalid_ShowAlert() {
        let baby = Person(name: nil, gender: Gender.none, parentName: nil, birthDay: "23" )
        viewModel = InformationViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.saveUserInformation(person: baby) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.isAlerted = true
                XCTAssertEqual(.invalidDateFormat, error)
            }
        }
    }

    func testSaveInfo_WhenBabyBirthDayIsNotvalid_ShowAlert() {
        let baby = Person(name: nil, gender: Gender.none, parentName: nil, birthDay: "23/02/2050" )
        viewModel = InformationViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.saveUserInformation(person: baby) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self.isAlerted = true
                XCTAssertEqual(.invalidDateBirth, error)
            }
        }
    }

    func testSaveInfo_WhenInfoIsOK_Success() {
        let baby = Person(name: "test", gender: Gender.girl, parentName: "Parent", birthDay: "23/02/2012" )
        viewModel = InformationViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.saveUserInformation(person: baby) { result in
            switch result {
            case .success:
                XCTAssertFalse(self.isAlerted)
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
        }
    }
}
