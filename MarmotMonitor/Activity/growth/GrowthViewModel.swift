//
//  GrowthViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 22/01/2024.
//

import Foundation

protocol GrowthDelegate: AnyObject {
    func nextView()
    func alert(title: String, description: String)
}

final class GrowthViewModel {

    private weak var delegate: GrowthDelegate?
    private var coreDataManager: MarmotMonitorSaveManager!

    let category: [GrowthField] = [.height, .weight, .head]
    var growthData : [String : Double] = [:]

    init(delegate: GrowthDelegate?, coreDataManager: MarmotMonitorSaveManager = MarmotMonitorSaveManager()) {
        self.delegate = delegate
        self.coreDataManager = coreDataManager
    }

    func setGrowth(with value: String? , inPosition position: Int) {
        guard position < category.count else { return }
        let category = category[position].title

        switch value?.contains(",") == true {
        case true:
            let formatedValue = value?.replacingOccurrences(of: ",", with: ".")
            guard let value = Double(formatedValue ?? "") else { return }
            growthData[category] = value
        case false:
            guard let value = Double(value ?? "") else { return }
            growthData[category] = value
        }
    }

    // MARK: - Core Data
    func saveGrowth(at date: Date) {
        guard !growthData.isEmpty else { return }

        let growthData = GrowthData(weight: growthData["Poids"] ?? 0,
                                height: growthData["Taille"] ?? 0,
                                headCircumference: growthData["Tour de tête"] ?? 0)

        coreDataManager.saveActivity(.growth(data: growthData),
                                     date: date,
                                     onSuccess: { self.delegate?.nextView() },
                                     onError: { description in self.showAlert(title: "Erreur", description: description) })
    }

    // MARK: - MarmotMonitorSaveManagerDelegate
    func showAlert(title: String, description: String) {
        delegate?.alert(title: title, description: description)
    }
}
