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
    private var coreDatatManager: MarmotMonitorSaveManager!
    
    private var isSave: Bool!
    
    override func setUp() {
        super.setUp()
        coreDatatManager = MarmotMonitorSaveManager(coreDataManager: CoreDataManagerMock.sharedInstance)
        viewModel = ApparenceSettingViewModel()
        
        isSave = false
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        coreDatatManager.clearDatabase()
        coreDatatManager = nil
    }

    // MARK: - test userdefault
    func testUserDefaultHaveData_WhenRequestLabelText_receiveApparence() {
        let date = Date().toStringWithDayMonthYear()
        let baby = Person(name: "Bébé", gender: "Fille", parentName: "Pierrick", birthDay: date )
        let viewModel = ApparenceSettingViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: baby))

        let texte = viewModel.getInitPositionOfSelected()

        XCTAssertEqual(texte, 0)
    }
}
