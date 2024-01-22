//
//  meal.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/12/2023.
//

import Foundation

enum Ingredient: String, CaseIterable {
    case fruit = "Fruit"
    case vegetable = "Légumes"
    case meat = "Viandes et protéines"
    case cereal = "Céréales"
    case dairyProduct = "Produits laitiers"
    case other = "Autre(s)"

    var index: Int? {
            return Ingredient.allCases.firstIndex(of: self)
    }
}
