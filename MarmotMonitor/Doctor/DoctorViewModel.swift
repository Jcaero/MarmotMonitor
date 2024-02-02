//
//  DoctorViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 02/02/2024.
//

import Foundation
import DGCharts

class DoctorViewModel {

    private let marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol!

    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 0),
        ChartDataEntry(x: 1, y: 1),
        ChartDataEntry(x: 2, y: 2),
        ChartDataEntry(x: 3, y: 3),
        ChartDataEntry(x: 4, y: 4),
        ChartDataEntry(x: 5, y: 2),
        ChartDataEntry(x: 6, y: 5),
        ChartDataEntry(x: 7, y: 8),
        ChartDataEntry(x: 8, y: 8),
        ChartDataEntry(x: 9, y: 9)]

    // MARK: - Init

    init(marmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol = MarmotMonitorSaveManager()) {
        self.marmotMonitorSaveManager = marmotMonitorSaveManager
    }
}
