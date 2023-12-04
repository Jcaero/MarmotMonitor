//
//  Date+.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 26/11/2023.
//

import Foundation

extension Date {

    func toStringWithDayMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }

    func toDateFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
