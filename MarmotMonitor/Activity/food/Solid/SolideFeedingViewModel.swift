//
//  SolideFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import Foundation

final class SolidFeedingViewModel {

    let ingredients: [Ingredient] = Ingredient.allCases
    var solidFood = SolidFood()

    func set(_ value: String, for ingredient: Int) {
        switch ingredient {
        case TextFieldData.fruit.rawValue :
            solidFood.fruit = Int(value) ?? 0
        case TextFieldData.vegetable.rawValue:
            solidFood.vegetable = Int(value) ?? 0
        case TextFieldData.meatAndProtein.rawValue:
            solidFood.meatAndProtein = Int(value) ?? 0
        case TextFieldData.cereal.rawValue:
            solidFood.cereal = Int(value) ?? 0
        case TextFieldData.dairyProduct.rawValue:
            solidFood.dairyProduct = Int(value) ?? 0
        case TextFieldData.other.rawValue:
            solidFood.other = Int(value) ?? 0
        default:
            break
        }
    }
}
