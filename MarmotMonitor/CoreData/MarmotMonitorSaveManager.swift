//
//  MarmotMonitorSaveManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
import CoreData
import UIKit

protocol MarmotMonitorSaveManagerProtocol {
    func saveActivity(_ activityType: ActivityType, date: Date, onSuccess: (() -> Void), onError: ((String) -> Void))
    func fetchDateActivitiesWithDate(from startDate: Date, to endDate: Date) -> [DateActivity]
    func fetchFirstActivity<T>(ofType type: T.Type) -> (activity: T, date: Date)? where T:Activity
    func clearDatabase()
}

final class MarmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol {

    // MARK: - Properties

    private let coreDataManager: CoreDataManagerProtocol
    private let context: NSManagedObjectContext!

    // MARK: - Init

    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.sharedInstance) {
        self.coreDataManager = coreDataManager
        context = coreDataManager.viewContext
    }

    // MARK: - Save
    /// Saves an activity to the database
    /// - Note: If no DateActivity object exists for the given date, one will be created
    /// - Note: If a DateActivity object already exists for the given date, the activity will be added to it
    /// - Note: If one of the same activity type already exists for the given date, an alert will be shown
    /// - Parameters:
    ///  - activityType: The type of activity to save
    ///  - date: The date to save the activity for
    func saveActivity(_ activityType: ActivityType, date: Date, onSuccess: (() -> Void), onError: ((String) -> Void)) {
        context.performAndWait {
            let activityDate = self.fetchOrCreateDateActivity(for: date)

            let activityExists = self.verifyExistenceOf(activityType, in: activityDate)
            guard !activityExists else {
                onError(activityType.alertMessage)
                return
            }

            switch activityType {
            case .diaper(let state):
                let diaper = Diaper(context: self.context)
                diaper.state = state.rawValue
                activityDate.addToActivity(diaper)

            case .bottle(let quantity):
                let bottle = Bottle(context: self.context)
                bottle.quantity = Int16(quantity)
                activityDate.addToActivity(bottle)

            case .breast(duration: let breastSession):
                let breast = Breast(context: self.context)
                breast.leftDuration = Int16(breastSession.leftDuration)
                breast.rightDuration = Int16(breastSession.rightDuration)
                activityDate.addToActivity(breast)

            case .sleep(duration: let duration):
                let sleep = Sleep(context: self.context)
                sleep.duration = Int16(duration)
                activityDate.addToActivity(sleep)

            case .growth(data: let growthData):
                let growth = Growth(context: self.context)
                growth.weight = growthData.weight
                growth.height = growthData.height
                growth.headCircumfeence = growthData.headCircumference
                activityDate.addToActivity(growth)

            case .solide(composition: let composition):
                let solid = Solid(context: self.context)
                solid.vegetable = Int16(composition.vegetable)
                solid.meat = Int16(composition.meat)
                solid.fruit = Int16(composition.fruit)
                solid.dairyProduct = Int16(composition.dairyProduct)
                solid.cereal = Int16(composition.cereal)
                solid.other = Int16(composition.other)
                activityDate.addToActivity(solid)
            }

            do {
                try self.coreDataManager.save()
                    onSuccess()
            } catch {
                    onError("Impossible de sauvegarder l'activité.")
            }
        }
    }

    private func verifyExistenceOf(_ activityType: ActivityType, in dateActivity: DateActivity) -> Bool {
        switch activityType {
        case .diaper:
            return dateActivity.activityArray.contains(where: { $0 as? Diaper != nil })
        case .bottle:
            return dateActivity.activityArray.contains(where: { $0 as? Bottle != nil })
        case .breast:
            return dateActivity.activityArray.contains(where: { $0 as? Breast != nil })
        case .sleep:
            return dateActivity.activityArray.contains(where: { $0 as? Sleep != nil })
        case .growth:
            return dateActivity.activityArray.contains(where: { $0 as? Growth != nil })
        case .solide:
            return dateActivity.activityArray.contains(where: { $0 as? Solid != nil })
        }
    }

    /// Fetches a DateActivity object for a given date, or creates one if none is found
    /// - Parameter date: The date to fetch or create an activity for
    /// - Returns: The DateActivity object for the given date
    /// - Note: If no DateActivity object exists for the given date, one will be created
    private func fetchOrCreateDateActivity(for date: Date) -> DateActivity {
        if let existingActivity = fetchDateActivity(for: date) {
            return existingActivity
        } else {
            return createDateActivity(for: date)
        }
    }

    /// Creates a DateActivity object for a given date
    /// - Parameter date: The date to create an activity for
    /// - Returns: The newly created DateActivity object
    private func createDateActivity(for date: Date) -> DateActivity {
        context.performAndWait {
            let newActivity = DateActivity(context: context)
            newActivity.date = date.removeSeconds()
            return newActivity
        }
    }

    // MARK: - Fetch
    /// Fetches DateActivity objects for a given date
    /// - Parameter date: The date to fetch activities for
    /// - Returns: The DateActivity object for the given date
    private func fetchDateActivity(for date: Date) -> DateActivity? {
        context.performAndWait {
            let fetchRequest: NSFetchRequest<DateActivity> = DateActivity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "date == %@", date.removeSeconds() as NSDate)
            fetchRequest.fetchLimit = 1

            do {
                let results = try context.fetch(fetchRequest)
                return results.first
            } catch {
                print("No date Activity found for \(date)")
                return nil
            }
        }
    }

    /// Fetches only all DateActivity objects between two dates
    /// - Parameters:
    ///  - startDate: The start date
    ///  - endDate: The end date
    ///  - Returns: The DateActivity objects between the two dates
    ///  - Note: The start date is included, the end date is excluded
    func fetchDateActivitiesWithDate(from startDate: Date, to endDate: Date) -> [DateActivity] {
        context.performAndWait {
            var fetchedResults = [DateActivity]()
            let request = NSFetchRequest<DateActivity>(entityName: "DateActivity")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

            let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
            request.predicate = predicate

            do {
                let results = try context.fetch(request)
                fetchedResults = results.filter { !$0.activityArray.isEmpty }
            } catch {
                print("Erreur lors de la récupération des activités: \(error)")
            }

            return fetchedResults
        }
    }

    private func fetchAllActivity() -> [DateActivity] {
        context.performAndWait {
            var fetchedResults = [DateActivity]()
            let request = NSFetchRequest<DateActivity>(entityName: "DateActivity")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

            do {
                let results = try context.fetch(request)
                fetchedResults = results.filter { !$0.activityArray.isEmpty }
            } catch {
                print("Erreur lors de la récupération des activités: \(error)")
            }

            return fetchedResults
        }
    }

    /// Fetches first activity of diaper
    /// - Returns: The first diaper activity
    /// - Note: If no diaper activity exists, returns nil
    func fetchFirstDiaperActivity() -> (activity: Diaper, date: Date)? {
        return fetchFirstActivity(ofType: Diaper.self)
//        let allActivities = fetchAllActivity()
//        let sortedActivities = allActivities.sorted { $0.date > $1.date }
//
//        for dateActivity in sortedActivities {
//            for activity in dateActivity.activityArray {
//                if let diaperActivity = activity as? Diaper {
//                    return (diaperActivity, dateActivity.date)
//                }
//            }
//        }
//        return nil
    }

    func fetchFirstBottleActivity() -> (activity: Bottle, date: Date)? {
        return fetchFirstActivity(ofType: Bottle.self)
//        let allActivities = fetchAllActivity()
//        let sortedActivities = allActivities.sorted { $0.date > $1.date }
//
//        for dateActivity in sortedActivities {
//            for activity in dateActivity.activityArray {
//                if let bottleActivity = activity as? Bottle {
//                    return (bottleActivity, dateActivity.date)
//                }
//            }
//        }
//        return nil
    }

    func fetchFirstBreastActivity() -> (activity: Breast, date: Date)? {
        return fetchFirstActivity(ofType: Breast.self)
//        let allActivities = fetchAllActivity()
//        let sortedActivities = allActivities.sorted { $0.date > $1.date }
//
//        for dateActivity in sortedActivities {
//            for activity in dateActivity.activityArray {
//                if let breastActivity = activity as? Breast {
//                    return (breastActivity, dateActivity.date)
//                }
//            }
//        }
//        return nil
    }

    func fetchFirstSolidActivity() -> (activity: Solid, date: Date)? {
        return fetchFirstActivity(ofType: Solid.self)
//        let allActivities = fetchAllActivity()
//        let sortedActivities = allActivities.sorted { $0.date > $1.date }
//
//        for dateActivity in sortedActivities {
//            for activity in dateActivity.activityArray {
//                if let solidActivity = activity as? Solid {
//                    return (solidActivity, dateActivity.date)
//                }
//            }
//        }
//        return nil
    }

    func fetchFirstActivity<T>(ofType type: T.Type) -> (activity: T, date: Date)? where T:Activity {
        let allActivities = fetchAllActivity().sorted { $0.date > $1.date }

        for dateActivity in allActivities {
            if let activity = dateActivity.activityArray.first(where: { $0 is T }) as? T {
                return (activity, dateActivity.date)
            }
        }
        return nil
    }

    // MARK: - Clear
    /// delete all data from database
    func clearDatabase() {
        coreDataManager.clearDatabase()
    }
}
