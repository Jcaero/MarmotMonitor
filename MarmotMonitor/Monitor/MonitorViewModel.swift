//
//  MonitorViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/01/2024.
//

import Foundation

class MonitorViewModel {
    private let saveManager: MarmotMonitorSaveManagerProtocol!
    var graphActivities: [String: [GraphActivity]] = [:]
    private var dateWithActivitySet: Set<Date> = []
    var dateWithActivity: [Date] {
        Array(dateWithActivitySet).sorted(by: { $0 > $1 })
    }

    init(saveManager: MarmotMonitorSaveManagerProtocol = MarmotMonitorSaveManager()) {
        self.saveManager = saveManager
    }

    func updateData() {
        let activities = saveManager.fetchAllActivity()
        graphActivities = createGraphElements(with: activities)
    }

    /// Create the graph elements from the activities
    /// - Parameter dateActivities: Array of DateActivity
    /// - Returns: Dictionary of GraphActivity with the date as key
    /// - Note: The date is converted to french timezone with no time
    /// - Note: The date is converted to string with the format dd/MM/yyyy
    private func createGraphElements( with dateActivities: [DateActivity]) -> [String: [GraphActivity]] {
        var elements: [String: [GraphActivity]] = [:]

        dateActivities.forEach { activities in
            let frenchDate = activities.date.convertToFrenchTimeZone()
            let stringDate = frenchDate.toStringWithDayMonthYear()

            activities.activityArray.forEach { activity in
                if let graphActivity = transformInGraphActivity(with: activity, date: activities.date) {
                    elements[stringDate, default: []].append(graphActivity)
                    dateWithActivitySet.insert(frenchDate.dateWithNoTime())
                }
            }
        }
        return elements
    }

    /// Transform an activity in a graph activity
    /// - Parameters:
    ///  - activity: Activity to transform
    ///  - date: Date of the activity
    ///  - Returns: GraphActivity
    ///  - Note: The duration is set to 29 min for all activities with no duartion
    ///  - Note: The duration is converted in min for breast and sleep
    private func transformInGraphActivity( with activity: Activity, date: Date) -> GraphActivity? {
        let timeStart = date
        switch activity {
        case is Diaper :
            return GraphActivity(type: .diaper, color: .yellow, timeStart: timeStart, duration: 29)

        case is Bottle :
            return GraphActivity(type: .bottle, color: .blue, timeStart: timeStart, duration: 29)

        case is Breast :
            guard let duration = (activity as? Breast)?.totalDuration else { return nil }
            let durationBreastInMin = Int(duration) / 60
            return GraphActivity(type: .breast, color: .red, timeStart: timeStart, duration: durationBreastInMin)

        case is Solid :
            return GraphActivity(type: .solid, color: .green, timeStart: timeStart, duration: 29)

        case is Sleep :
            guard let durationSleep = (activity as? Sleep)?.duration else { return nil }
            let durationSleepInMin = Int(durationSleep) / 60
            return GraphActivity(type: .sleep, color: .purple, timeStart: timeStart, duration: durationSleepInMin)
        default:
            return nil
        }
    }
}
