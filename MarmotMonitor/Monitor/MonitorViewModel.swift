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
    var summaryActivities: [String: [String: String]] = [:]

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
        summaryActivities = createSummaryActivities(with: activities)
    }

    func createSummaryActivities(with dateActivities: [DateActivity]) -> [String: [String: String]] {
        var values: [String: [String: String]] = [:]

        dateActivities.forEach { activities in
            let frenchDate = activities.date.convertToFrenchTimeZone()
            let stringDate = frenchDate.toStringWithDayMonthYear()
            values[stringDate] = summaryActivities(activities: activities.activityArray)
        }
        return values
    }

    /// Create the summary of the activities for a date
    /// - Parameter date: Date of the summary
    /// - Returns: Dictionary of String with the icon name as key and the summary as value
    /// - Note: The summary is the number of time for diaper and meal (only bottle and solid)
    /// - Note: The summary is the number of time and the total time for sleep or breast
    func summaryActivities(activities: [Activity] ) -> [String : String] {
        var diaper : ActivitySummary = ActivitySummary()
        var meal : ActivitySummary = ActivitySummary()
        var sleep : ActivitySummary = ActivitySummary()

        activities.forEach { activity in
            switch activity {
            case is Diaper:
                diaper.count += 1
            case is Solid, is Bottle:
                meal.count += 1
            case is Breast:
                if let breastActivity = activity as? Breast {
                    meal.totalTime += breastActivity.totalDuration
                    meal.count += 1
                }
            case is Sleep:
                if let sleepActivity = activity as? Sleep {
                    sleep.totalTime += Int(sleepActivity.duration)
                    sleep.count += 1
                }
            default:
                break
            }
        }

        return [
            ActivityIconName.diaper.rawValue: transformInString(activity: diaper),
            ActivityIconName.meal.rawValue: transformInString(activity: meal),
            ActivityIconName.sleep.rawValue: transformInString(activity: sleep)
        ]
    }

    // MARK: - Private
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

    private func transformInString( activity: ActivitySummary) -> String {
        if activity.totalTime == 0 {
            return "\n\(activity.count) fois"
        } else {
            let totalTime = activity.totalTime.toTimeString()
            return totalTime + "\n\(activity.count) fois"
        }
    }
}

// MARK: - ActivitySummary
struct ActivitySummary: Equatable {
    var count = 0
    var totalTime = 0
}
