//
//  MarmotMonitorSaveManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
import CoreData
import UIKit

protocol MarmotMonitorSaveManagerProtocol {
    func saveActivity(_ activityType: ActivityType, date: Date)
    func fetchDateActivitiesWithDate(from startDate: Date, to endDate: Date) -> [DateActivity]
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
    /// - Parameters:
    ///  - activityType: The type of activity to save
    ///  - date: The date to save the activity for
    func saveActivity(_ activityType: ActivityType, date: Date) {
        let activityDate = fetchOrCreateDateActivity(for: date)

        switch activityType {
        case .diaper(let state):
            let diaper = Diaper(context: context)
            diaper.state = state.rawValue
            activityDate.addToActivity(diaper)

        case .bottle(let quantity):
            let bottle = Bottle(context: context)
            bottle.quantity = Int16(quantity)
            activityDate.addToActivity(bottle)
        }
        coreDataManager.save()
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
        let newActivity = DateActivity(context: context)
        newActivity.date = date
        return newActivity
    }

    // MARK: - Fetch
    /// Fetches DateActivity objects for a given date
    /// - Parameter date: The date to fetch activities for
    /// - Returns: The DateActivity object for the given date
    private func fetchDateActivity(for date: Date) -> DateActivity? {
        let fetchRequest: NSFetchRequest<DateActivity> = DateActivity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("No date Activity found for \(date)")
            return nil
        }
    }

//    /// Fetches all DateActivity objects from the last 7 days
//    func fetchDateActivities() -> [DateActivity] {
//        var fetchedResults = [DateActivity]()
//
//            let request = NSFetchRequest<DateActivity>(entityName: "DateActivity")
//            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//
//            // Prépare un prédicat pour filtrer les activités des 7 derniers jours
//            let calendar = Calendar.current
//            let startDate = calendar.date(byAdding: .day, value: -7, to: Date())!
//            let endDate = calendar.startOfDay(for: Date())
//            let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
//            request.predicate = predicate
//
//            do {
//                let results = try context.fetch(request)
//                // Enlève les dates sans activités
//                fetchedResults = results.filter { !$0.activityArray.isEmpty }
//            } catch {
//                print("Erreur lors de la récupération des activités: \(error)")
//            }
//
//        return fetchedResults
//    }

    /// Fetches only all DateActivity objects between two dates
    /// - Parameters:
    ///  - startDate: The start date
    ///  - endDate: The end date
    ///  - Returns: The DateActivity objects between the two dates
    ///  - Note: The start date is included, the end date is excluded
    func fetchDateActivitiesWithDate(from startDate: Date, to endDate: Date) -> [DateActivity] {
        var fetchedResults = [DateActivity]()

        let request = NSFetchRequest<DateActivity>(entityName: "DateActivity")
//          Ici ou dans le fichier DataProprieties via le sorted  activityArray
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

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

    // MARK: - Clear
    /// delete all data from database
    func clearDatabase() {
        coreDataManager.clearDatabase()
    }
}
