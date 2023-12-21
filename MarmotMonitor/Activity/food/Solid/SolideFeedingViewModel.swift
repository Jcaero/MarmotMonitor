//
//  SolideFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

protocol SolideFeedingProtocol: AnyObject {
    func updateTotal(with total: String)
}

import Foundation

final class SolidFeedingViewModel {
    private weak var delegate: SolideFeedingProtocol?

    let ingredients: [Ingredient] = Ingredient.allCases
    var solidFood : [Ingredient : Int] = [:]

    init(delegate: SolideFeedingProtocol?) {
        self.delegate = delegate
    }

    func set(_ value: String, for ingredient: Ingredient) {
        guard let value = Int(value) else { return }
        solidFood[ingredient] = value
    }

    func updateTotal() {
        var total = 0
        solidFood.forEach { (_ , value) in
            total += value
        }
        let text = "Total = " + "\(total) g"
        delegate?.updateTotal(with: text)
    }
}
