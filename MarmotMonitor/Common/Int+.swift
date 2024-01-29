//
//  Int+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 12/12/2023.
//

import Foundation

extension Int {
    /// Convert the Int of minute  into a String with the format HH:MM
    func toTimeString() -> String {
        let minutes = (self / 60) % 60
        let hours = self / 3600

        if hours == 0 {
            return String(format: "%02d min", minutes)
        } else {
            if minutes == 0 {
                return String(format: "%02d H", hours)
            } else {
                return String(format: "%02d H %02d min", hours, minutes)
            }
        }
    }

    // Convert Int value represent seconds to minutes
    func inMinutes() -> Int {
           return Int(self) / 60
       }
}
