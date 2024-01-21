//
//  SolideFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/12/2023.
//

import Foundation

protocol SolideFeedingProtocol: AnyObject {
    func updateTotal(with total: String)
    func nextView()
    func alert(title: String, description: String)
}

final class SolidFeedingViewModel {
    private weak var delegate: SolideFeedingProtocol?
    private var coreDataManager: MarmotMonitorSaveManager!

    let ingredients: [Ingredient] = Ingredient.allCases
    var solidFood : [Ingredient : Int] = [:]

    var totalFood: Int {
        solidFood.reduce(0) { $0 + $1.value }
    }

    init(delegate: SolideFeedingProtocol?, coreDataManager: MarmotMonitorSaveManager = MarmotMonitorSaveManager()) {
        self.delegate = delegate
        self.coreDataManager = coreDataManager
    }

    func set(_ value: String, for ingredient: Ingredient) {
        guard let intValue = Int(value), intValue >= 0 else {
            showAlert(title: "Erreur de saisie", description: "Veuillez entrer une valeur positive")
            return
        }
        solidFood[ingredient] = intValue
        updateTotal()
    }

    private func updateTotal() {
        let text = "Total = " + "\(totalFood) g"
        delegate?.updateTotal(with: text)
    }

    // MARK: - Core Data
    func saveSolid(at date: Date) {
        guard totalFood != 0 else {
            showAlert(title: "Erreur", description: "Aucun aliment n'a été enregistré")
            return
        }

        let foods = createSolidQuantity()

        coreDataManager.saveActivity(.solide(composition: foods),
                                     date: date,
                                     onSuccess: { self.delegate?.nextView() },
                                     onError: { description in self.showAlert(title: "Erreur", description: description) })
    }

    private func createSolidQuantity() -> SolidQuantity {
        return SolidQuantity(vegetable: solidFood[.vegetable] ?? 0,
                             meat: solidFood[.meat] ?? 0,
                             fruit: solidFood[.fruit] ?? 0,
                             dairyProduct: solidFood[.dairyProduct] ?? 0,
                             cereal: solidFood[.cereal] ?? 0,
                             other: solidFood[.other] ?? 0)
    }

    // MARK: - Alert
    private func showAlert(title: String, description: String) {
        delegate?.alert(title: title, description: description)
    }
}
