//
//  SolidFeedingViewModel.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 17/01/2024.
//

import Foundation
import XCTest
@testable import MarmotMonitor

class SolidFeedingViewModelTest: XCTestCase {

    private var viewModel: SolidFeedingViewModel!
    
    private var totalFood: String!

    override func setUp() {
        super.setUp()
        viewModel = SolidFeedingViewModel(delegate: self)
        totalFood = "0"
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testWhenSetOneIngredient_IngredientIsInsert() {
        
        viewModel.set("100", for: .cereal)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], 100)
        XCTAssertEqual(viewModel.solidFood[.fruit], nil)
        XCTAssertEqual(totalFood, "Total = 100 g")
        
    }

    func testWhenSetTwoIngredients_IngredientsIsInsert() {
        
        viewModel.set("100", for: .cereal)
        viewModel.set("200", for: .fruit)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], 100)
        XCTAssertEqual(viewModel.solidFood[.fruit], 200)
        XCTAssertEqual(viewModel.solidFood[.meatAndProtein], nil)
        XCTAssertEqual(totalFood, "Total = 300 g")
    }

    func testWhenSetString_IngredientsIsNotInsert() {
        
        viewModel.set("test", for: .cereal)
        viewModel.set("200", for: .fruit)
        
        XCTAssertEqual(viewModel.solidFood[.cereal], nil)
        XCTAssertEqual(viewModel.solidFood[.fruit], 200)
        XCTAssertEqual(totalFood, "Total = 200 g")
    }
}

extension SolidFeedingViewModelTest: SolideFeedingProtocol {
    func updateTotal(with total: String) {
        totalFood = total
    }
}
