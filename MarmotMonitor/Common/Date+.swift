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

    func removeSeconds() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)!
    }

    func toStringWithTimeAndDayMonthYear() -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current

        let currentDate = calendar.startOfDay(for: Date())
        let selectedDate = calendar.startOfDay(for: self)

        dateFormatter.dateFormat = currentDate == selectedDate ? "HH:mm" : "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: self)
    }

    func getHourAndMin() -> (hour: Int?, min: Int?) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: self)
        return (dateComponents.hour, dateComponents.minute)
    }
}
