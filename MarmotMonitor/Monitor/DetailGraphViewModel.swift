//
//  DetailGraphViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 21/02/2024.
//

import Foundation

class DetailGraphViewModel {
    private var coreDataManager: MarmotMonitorSaveManager!

    var data: [GraphActivity] = []

    var numberOfRow: Int {
        data.count
    }

    // MARK: - Init
    init(coreDataManager: MarmotMonitorSaveManager = MarmotMonitorSaveManager()) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Function
    func setDatas(data: [GraphActivity]) {
        self.data = data
    }

    func getValue(for index: Int) -> String {
        let activity = data[index]
        switch activity.type {
        case .diaper, .breast, .solid:
            return ""
        case .bottle:
            if let quantity = activity.quantity {
                return "\(quantity) ml"
            } else {
                return ""
            }
        case .sleep:
            let duration = activity.duration
            return duration.toTimeString()
        }
    }

    func deleteActivity(at index: Int) {
        let activity = data[index]
        coreDataManager.deleteActivity(ofType: activity.type, date: activity.timeStart) {
            data.remove(at: index)
        } onError: { error in
            print("erreur de supression")
        }
    }
}
