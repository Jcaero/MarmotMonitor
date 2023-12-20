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
    case meatAndProtein = "Viandes et protéines"
    case cereal = "Céréales"
    case dairyProduct = "Produits laitiers"
    case other = "Autre(s)"
}

struct SolidFood {
    var fruit: Int = 0
    var vegetable: Int = 0
    var meatAndProtein: Int = 0
    var cereal: Int = 0
    var dairyProduct: Int = 0
    var other: Int = 0

    var totalWeight: Int {
        return fruit + vegetable + meatAndProtein + cereal + dairyProduct + other
    }
}
