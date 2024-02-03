//
//  DoctorViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/02/2024.
//

import Foundation
import DGCharts

class DoctorViewModel {
    private let userDefaultsManager: UserDefaultManagerProtocol!
    private let saveManager: MarmotMonitorSaveManagerProtocol!

    var heightValues: [ChartDataEntry] = []
    var weightValues: [ChartDataEntry] = []

    // MARK: - Init

    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager(), saveManager: MarmotMonitorSaveManagerProtocol = MarmotMonitorSaveManager()) {
        self.userDefaultsManager = userDefaultsManager
        self.saveManager = saveManager
    }

    func updateData() {
        let data = saveManager.fetchGrowthActivity()

        data.forEach { (date,growth) in
            let day = numberOfWeekSinceBirth(date: date)
            let dataHeight = growth.height
            let dataWeight = growth.weight
            let hValue = ChartDataEntry(x: day, y: dataHeight)
            heightValues.append(hValue)

            let wValue = ChartDataEntry(x: day, y: dataWeight)
            weightValues.append(wValue)
        }
    }

    private func numberOfWeekSinceBirth( date: Date) -> Double {
        let birthDate = userDefaultsManager.getBirthDay()?.toDate() ?? Date()
        guard let day = Calendar.current.dateComponents([.day], from: birthDate, to: date).day 
            else {
                return 0.0
            }
        return Double(day) / 7
    }

}
