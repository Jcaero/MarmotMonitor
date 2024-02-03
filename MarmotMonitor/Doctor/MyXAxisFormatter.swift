//
//  MyXAxisFormatter.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 03/02/2024.
//

import Foundation
import DGCharts

class CustomAxisValueFormatter: NSObject, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        return "semaine \(Int(value))"
    }
}
