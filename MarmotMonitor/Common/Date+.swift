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

    func convertToFrenchTimeZone() -> Date {
            guard let timeZone = TimeZone(identifier: "Europe/Paris") else { return self }
            let timeZoneOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            return self.addingTimeInterval(timeZoneOffset)
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

    func inMinute() -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: self)

        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0

        return hour * 60 + minute
    }

    func dateWithNoTime() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: dateComponents)!
    }

    func toStringWithOnlyTime() -> String {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: self)
        let date = calendar.date(from: dateComponents)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
