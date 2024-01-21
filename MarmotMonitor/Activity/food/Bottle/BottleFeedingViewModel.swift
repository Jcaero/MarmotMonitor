//
//  BottleFeedingViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 20/01/2024.
//

import Foundation

protocol BottleFeedingDelegate: AnyObject {
    func nextView()
    func alert(title: String, description: String)
}

final class BottleFeedingViewModel {

    private weak var delegate: BottleFeedingDelegate?
    private var coreDataManager: MarmotMonitorSaveManager!

    private var bottleQuantity: Int = 0

    init(delegate: BottleFeedingDelegate?, coreDataManager: MarmotMonitorSaveManager = MarmotMonitorSaveManager()) {
        self.delegate = delegate
        self.coreDataManager = coreDataManager
    }

    // MARK: - Core Data
    func saveBottle(at date: Date) {
        guard bottleQuantity != 0
        else {
            showAlert(title: "Erreur", description: "Aucune quantité rentrée")
            return
        }

        coreDataManager.saveActivity(.bottle(quantity: bottleQuantity),
                                     date: date,
                                     onSuccess: { self.delegate?.nextView() },
                                     onError: { description in self.showAlert(title: "Erreur", description: description) })
    }

    func setQuantity( _ quantity: Int) {
        bottleQuantity = quantity
    }

    // MARK: - Alert
    private func showAlert(title: String, description: String) {
        delegate?.alert(title: title, description: description)
    }
}
