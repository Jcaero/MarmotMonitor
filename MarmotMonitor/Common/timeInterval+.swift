//
//  timeInterval+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 16/01/2024.
//

import Foundation
extension TimeInterval {

    func toStringWithHourAndMinute() -> String {
        let duration = Int(self)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60

        return "\(hours)h \(minutes)min"
    }
}
