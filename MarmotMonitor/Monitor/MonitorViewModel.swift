//
//  MonitorViewModel.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 24/01/2024.
//

import Foundation

class MonitorViewModel {
    private let saveManager: MarmotMonitorSaveManagerProtocol!
    private let userDefaultsManager: UserDefaultManagerProtocol!

    var graphActivities: [String: [GraphActivity]] = [:]
    var summaryActivities: [String: [String: String]] = [:]

    var filterStatus: [String : Bool] = [ActivityIconName.sleep.rawValue: false, ActivityIconName.meal.rawValue: false, ActivityIconName.diaper.rawValue: false]
    var filterButton: [String] {
        filterStatus.keys.sorted(by: { $0 > $1 })
    }

    private var dateWithActivitySet: Set<Date> = []
    var dateWithActivity: [Date] {
        Array(dateWithActivitySet).sorted(by: { $0 > $1 })
    }

    // MARK: - Init
    init(userDefaultsManager: UserDefaultManagerProtocol = UserDefaultsManager(), saveManager: MarmotMonitorSaveManagerProtocol = MarmotMonitorSaveManager()) {
        self.saveManager = saveManager
        self.userDefaultsManager = userDefaultsManager
    }

    // MARK: - Function
    private func cleanAllData() {
        graphActivities = [:]
        summaryActivities = [:]
        dateWithActivitySet = []
    }

    func updateData() {
        cleanAllData()
        let activities = saveManager.fetchAllActivity()
        createGraphElements(with: activities)
        summaryActivities = createSummaryActivities(with: graphActivities)
    }

    func createSummaryActivities(with graphData: [String: [GraphActivity]]) -> [String: [String: String]] {
        var values: [String: [String: String]] = [:]
        let dates = graphData.keys.sorted(by: { $0 > $1 })

        dates.forEach { date in
            if let graphActivities = graphData[date] {
                values[date] = summaryActivities(graphActivities: graphActivities)
            }
        }
        return values
    }

    /// Create the summary of the activities for a date
    /// - Parameter date: Date of the summary
    /// - Returns: Dictionary of String with the icon name as key and the summary as value
    /// - Note: The summary is the number of time for diaper and meal (only bottle and solid)
    /// - Note: The summary is the number of time and the total time for sleep or breast
    func summaryActivities(graphActivities: [GraphActivity] ) -> [String : String] {
        var diaper : ActivitySummary = ActivitySummary()
        var meal : ActivitySummary = ActivitySummary()
        var sleep : ActivitySummary = ActivitySummary()

        graphActivities.forEach { activity in
            switch activity.type {
            case .diaper:
                diaper.count += 1
            case .solid, .breast:
                meal.count += 1
            case .bottle:
                if let quantity = activity.quantity {
                    meal.quantity += quantity
                }
                meal.count += 1
            case .sleep:
                sleep.duration += activity.duration
                sleep.count += 1
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
    private func createGraphElements( with dateActivities: [DateActivity]) {
        dateActivities.forEach { activities in
            let date = activities.date
            let nextDay = date.dateByAddingDays(1)

            activities.activityArray.forEach { activity in
                if isFilterActive(for: activity) == false {
                    let graphActivity = transformInGraphActivity(with: activity, date: activities.date)
                    addGraphActivity(activity: graphActivity[0], date: date)

                    if graphActivity.count > 1 {
                        addGraphActivity(activity: graphActivity[1], date: nextDay)
                    }
                }
            }
        }
    }

    private func addGraphActivity( activity: GraphActivity, date: Date) {
        let stringDate = date.toStringWithDayMonthYear()

        graphActivities[stringDate, default: []].append(activity)
        dateWithActivitySet.insert(date.dateWithNoTime())
    }

    /// Transform an activity in a graph activity
    /// - Parameters:
    ///  - activity: Activity to transform
    ///  - date: Date of the activity
    ///  - Returns: GraphActivity
    ///  - Note: The duration is set to 29 min for all activities with no duartion
    ///  - Note: The duration is converted in min for breast and sleep
    private func transformInGraphActivity( with activity: Activity, date: Date) -> [GraphActivity] {
        let timeStart = date
        switch activity {
        case is Diaper :
            return [GraphActivity(type: .diaper, color: .colorForDiaper, timeStart: timeStart, duration: 0)]

        case is Bottle :
            guard let quantity = (activity as? Bottle)?.quantity else { return [] }
            return [GraphActivity(type: .bottle, color: .colorForMeal, timeStart: timeStart, duration: 0, quantity: Int(quantity))]

        case is Breast :
            guard let activity = activity as? Breast else { return [] }
            let graphActivity = transformInGraphActivityBreastActivity(with: activity , startActivity: date)
            return graphActivity

        case is Solid :
            return [GraphActivity(type: .solid, color: .colorForMeal, timeStart: timeStart, duration: 0)]

        case is Sleep :
            guard let activity = activity as? Sleep else { return [] }
            let graphActivity = transformInGraphActivitySleepActivity(with: activity , startActivity: date)
            return graphActivity
        default:
            return []
        }
    }

    private func transformInGraphActivityBreastActivity( with activity: Breast, startActivity: Date) -> [GraphActivity] {
        let duration = activity.totalDuration
        let nextDay = startActivity.endOfDay().addingTimeInterval(1)

        let endActivity = startActivity.addingTimeInterval(TimeInterval(duration))

        if endActivity < nextDay {
            return [GraphActivity(type: .breast, color: .colorForMeal, timeStart: startActivity, duration: duration)]
        } else {
            let timeEnd = startActivity.endOfDay()
            let timeEndDuration = Int(timeEnd.timeIntervalSince(startActivity)) + 1
            let graphActivity = [
                GraphActivity(type: .breast, color: .colorForMeal, timeStart: startActivity, duration: timeEndDuration),
                GraphActivity(type: .breast, color: .colorForMeal, timeStart: nextDay, duration: duration - timeEndDuration, timeOfOrigine: startActivity)]

            return graphActivity
        }
    }

    private func transformInGraphActivitySleepActivity( with activity: Sleep, startActivity: Date) -> [GraphActivity] {
        let duration = Int(activity.duration)
        let nextDay = startActivity.endOfDay().addingTimeInterval(1)

        let endActivity = startActivity.addingTimeInterval(TimeInterval(duration))

        if endActivity < nextDay {
            return [GraphActivity(type: .sleep, color: .colorForSleep, timeStart: startActivity, duration: duration)]
        } else {
            let timeEnd = startActivity.endOfDay()
            let timeEndDuration = Int(timeEnd.timeIntervalSince(startActivity)) + 1
            let graphActivity = [
                GraphActivity(type: .sleep, color: .colorForSleep, timeStart: startActivity, duration: timeEndDuration),
                GraphActivity(type: .sleep, color: .colorForSleep, timeStart: nextDay, duration: duration - timeEndDuration, timeOfOrigine: startActivity)]

            return graphActivity
        }
    }

    private func transformInString( activity: ActivitySummary) -> String {
        if activity.quantity != 0 {
            return "\(activity.quantity) ml\n\(activity.count) fois"
        } else if activity.duration == 0 {
            return "\n\(activity.count) fois"
        } else {
            let totalTime = activity.duration.toTimeString()
            return totalTime + "\n\(activity.count) fois"
        }
    }
}

// MARK: - Filter
extension MonitorViewModel {
    func toggleFilter(for filter: String) {
        guard let currentStatus = filterStatus[filter] else { return }
        filterStatus[filter] = !currentStatus
    }

    private func isFilterActive(for activity: Activity) -> Bool {
        switch activity {
        case is Diaper :
            return filterStatus[ActivityIconName.diaper.rawValue] ?? false
        case is Bottle, is Breast, is Solid :
            return filterStatus[ActivityIconName.meal.rawValue] ?? false
        case is Sleep :
            return filterStatus[ActivityIconName.sleep.rawValue] ?? false
        default:
            return true
        }
    }

    // MARK: - Type Graph
    func getGraphStyle() -> GraphType {
        return userDefaultsManager.getGraphType() ?? .rod
    }
}

// MARK: - ActivitySummary
struct ActivitySummary: Equatable {
    var count = 0
    var duration = 0
    var quantity = 0
}
