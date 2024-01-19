//
//  DiaperViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 18/01/2024.
//

import Foundation

protocol DiaperDelegate: AnyObject {
    func updateData()
    func nextView()
    func alert(title: String, description: String)
}

final class DiaperViewModel {

    private weak var delegate: DiaperDelegate?
    private var coreDataManager: MarmotMonitorSaveManager!

    let diaperStates = DiaperState.allCases
    var diaperStatus: [DiaperState: Bool] = [
        .wet: false,
        .dirty: false,
        .both: false
    ]

    init(delegate: DiaperDelegate?, coreDataManager: MarmotMonitorSaveManager? = nil) {
        self.delegate = delegate
        self.coreDataManager = coreDataManager ?? MarmotMonitorSaveManager()
    }

    func selectDiaper( diaper: DiaperState) {
        if let status = diaperStatus[diaper] {
            resetDiaperStatus()
            diaperStatus[diaper] = !status
        }
        delegate?.updateData()
    }

    private func resetDiaperStatus() {
        diaperStatus = [
            .wet: false,
            .dirty: false,
            .both: false
        ]
    }

    // MARK: - Core Data
    func saveDiaper(at date: Date) {
        guard let state = firstTrueDiaperState() else { return }
        coreDataManager.saveActivity(.diaper(state: state),
                                     date: date,
                                     onSuccess: { self.delegate?.nextView() },
                                     onError: { description in self.showAlert(title: "Erreur", description: description) })
    }

    private func firstTrueDiaperState() -> DiaperState? {
        for (state, isChanged) in diaperStatus where isChanged {
            return state
        }
        return nil
    }

    // MARK: - MarmotMonitorSaveManagerDelegate
    func showAlert(title: String, description: String) {
        delegate?.alert(title: title, description: description)
        print("diaperViewModel erreur")
    }
}
