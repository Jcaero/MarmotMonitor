//
//  GraphTypeViewModelTest.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 23/02/2024.
//
import XCTest
@testable import MarmotMonitor

final class GraphTypeViewModelTest: TestCase {
    
    private var viewModel: GraphtypeViewModel!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

    func testUserDefaultHavePixelType_WhenRequestGraphType_PixelIsTrue() {
        viewModel = GraphtypeViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .round))
        
        XCTAssertEqual(true , viewModel.graphType[0].1)
        XCTAssertEqual(false , viewModel.graphType[1].1)
        XCTAssertEqual(false , viewModel.graphType[2].1)
    }

    func testUserDefaultHaveRodType_WhenRequestGraphType_RodIsTrue() {
        viewModel = GraphtypeViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .rod))
        
        XCTAssertEqual(false , viewModel.graphType[0].1)
        XCTAssertEqual(true , viewModel.graphType[1].1)
        XCTAssertEqual(false , viewModel.graphType[2].1)
    }

    func testUserDefaultHaveLigneType_WhenRequestGraphType_LigneIsTrue() {
        viewModel = GraphtypeViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .ligne))
        
        XCTAssertEqual(false , viewModel.graphType[0].1)
        XCTAssertEqual(false , viewModel.graphType[1].1)
        XCTAssertEqual(true , viewModel.graphType[2].1)
    }

    // MARK: - Test select graphType
    func testUserDefaultHaveLigneType_WhenSelectRod_LigneIsFalseAndRodIsTrue() {
        viewModel = GraphtypeViewModel(userDefaultsManager: UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .ligne))
        
        XCTAssertEqual(false , viewModel.graphType[0].1)
        XCTAssertEqual(false , viewModel.graphType[1].1)
        XCTAssertEqual(true , viewModel.graphType[2].1)

        viewModel.graphTypeSelected(index: 1)

        XCTAssertEqual(false , viewModel.graphType[0].1)
        XCTAssertEqual(true , viewModel.graphType[1].1)
        XCTAssertEqual(false , viewModel.graphType[2].1)
    }

    // MARK: - Test save graphType
    func testUserDefault_WhenSavePixel_PixelIsSave() {
        let userDefaultsManager = UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .ligne)
        viewModel = GraphtypeViewModel(userDefaultsManager: userDefaultsManager)

        viewModel.graphTypeSelected(index: 0)
        viewModel.saveGraphType()
        viewModel.initGraphtype()

        XCTAssertEqual(true , viewModel.graphType[0].1)
        XCTAssertEqual(false , viewModel.graphType[1].1)
        XCTAssertEqual(false , viewModel.graphType[2].1)
    }

    func testUserDefault_WhenSaveRod_RodIsSave() {
        let userDefaultsManager = UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .ligne)
        viewModel = GraphtypeViewModel(userDefaultsManager: userDefaultsManager)

        viewModel.graphTypeSelected(index: 1)
        viewModel.saveGraphType()
        viewModel.initGraphtype()

        XCTAssertEqual(false , viewModel.graphType[0].1)
        XCTAssertEqual(true , viewModel.graphType[1].1)
        XCTAssertEqual(false , viewModel.graphType[2].1)
    }

    func testUserDefault_WhenSaveLigne_LigneIsSave() {
        let userDefaultsManager = UserDefaultsManagerMock(mockPerson: mockNilPerson, graphType: .rod)
        viewModel = GraphtypeViewModel(userDefaultsManager: userDefaultsManager)

        viewModel.graphTypeSelected(index: 2)
        viewModel.saveGraphType()
        viewModel.initGraphtype()

        XCTAssertEqual(false , viewModel.graphType[0].1)
        XCTAssertEqual(false , viewModel.graphType[1].1)
        XCTAssertEqual(true , viewModel.graphType[2].1)
    }
}
