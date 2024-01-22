//
//  Int+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2023.
//

import Foundation

extension Int {
    func toTimeString() -> String {
        let minutes = (self / 60) % 60
        let hours = self / 3600

        if hours == 0 {
            return String(format: "%02d min", minutes)
        } else {
            return String(format: "%02d H %02d min", hours, minutes)
        }
    }
}
