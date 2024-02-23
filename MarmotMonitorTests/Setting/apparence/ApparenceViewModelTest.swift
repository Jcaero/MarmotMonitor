//
//  ApparenceViewMdelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 14/02/2024.
//
import XCTest
@testable import MarmotMonitor

final class ApparenceViewModelTest: TestCase {
    
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

    // MARK: - test userdefault
    func testUserDefaultHaveData_WhenRequestPosition_receiveApparence() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let texte = viewModel.getInitPositionOfSelected()

        XCTAssertEqual(texte, 0)
    }

    func test_WhenSaveDataLight_ApparenceIsSave() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        let previousSaveApparence = viewModel.apparence

        viewModel.saveAparenceSetting(type: 1)

        let saveApparence = viewModel.apparence

        XCTAssertNotEqual(previousSaveApparence, saveApparence)
        XCTAssertEqual(UIUserInterfaceStyle.light , saveApparence)
        XCTAssertEqual(viewModel.getInitPositionOfSelected(), 1)
    }

    func test_WhenSaveDataDark_ApparenceIsSave() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        let previousSaveApparence = viewModel.apparence

        viewModel.saveAparenceSetting(type: 2)

        let saveApparence = viewModel.apparence

        XCTAssertNotEqual(previousSaveApparence, saveApparence)
        XCTAssertEqual(UIUserInterfaceStyle.dark , saveApparence)
        XCTAssertEqual(viewModel.getInitPositionOfSelected(), 2)
    }

    func test_WhenSaveDataUnspesified_ApparenceIsSave() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        viewModel.saveAparenceSetting(type: 2)
        let previousSaveApparence = viewModel.apparence

        viewModel.saveAparenceSetting(type: 0)

        let saveApparence = viewModel.apparence

        XCTAssertNotEqual(previousSaveApparence, saveApparence)
        XCTAssertEqual(UIUserInterfaceStyle.unspecified , saveApparence)
        XCTAssertEqual(viewModel.getInitPositionOfSelected(), 0)
    }

    // MARK: - test colorOfBackground
    func testUserIsBoy_WhenGetColorOfBackground_colorIsBlue() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .boy, parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        let color = viewModel.colorOfBackground

        XCTAssertEqual(color, .colorForGradientStart)
    }

    func testUserIsGirl_WhenGetColorOfBackground_colorIsPink() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: .girl, parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))
        
        let color = viewModel.colorOfBackground

        XCTAssertEqual(color, .colorForGradientStartPink)
    }
}
