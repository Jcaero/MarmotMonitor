//
//  MarmotMonitorSaveManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
import CoreData
import UIKit

protocol MarmotMonitorSaveManagerDelegate: AnyObject {
    func showAlert(title: String, description: String)
}

protocol MarmotMonitorSaveManagerProtocol {
    func saveActivity(_ activityType: ActivityType, date: Date)
    func fetchDateActivitiesWithDate(from startDate: Date, to endDate: Date) -> [DateActivity]
    func clearDatabase()
}

final class MarmotMonitorSaveManager: MarmotMonitorSaveManagerProtocol {

    // MARK: - Properties

    private let coreDataManager: CoreDataManagerProtocol
    private let context: NSManagedObjectContext!
    private weak var delegate: MarmotMonitorSaveManagerDelegate?

    // MARK: - Init

    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.sharedInstance, delegate: MarmotMonitorSaveManagerDelegate?) {
        self.coreDataManager = coreDataManager
        context = coreDataManager.viewContext
        self.delegate = delegate
    }

    // MARK: - Save
    /// Saves an activity to the database
    /// - Note: If no DateActivity object exists for the given date, one will be created
    /// - Note: If a DateActivity object already exists for the given date, the activity will be added to it
    /// - Note: If one of the same activity type already exists for the given date, an alert will be shown
    /// - Parameters:
    ///  - activityType: The type of activity to save
    ///  - date: The date to save the activity for
    func saveActivity(_ activityType: ActivityType, date: Date) {
        let activityDate = fetchOrCreateDateActivity(for: date)

        let activityExists = verifyExistenceOf(activityType, in: activityDate)
        guard !activityExists else {
            delegate?.showAlert(title: "Erreur", description: activityType.alertMessage)
            return
        }

        switch activityType {
        case .diaper(let state):
            let diaper = Diaper(context: context)
            diaper.state = state.rawValue
            activityDate.addToActivity(diaper)

        case .bottle(let quantity):
            let bottle = Bottle(context: context)
            bottle.quantity = Int16(quantity)
            activityDate.addToActivity(bottle)

        case .breast(duration: let breastSession):
            let breast = Breast(context: context)
            breast.leftDuration = Int16(breastSession.leftDuration)
            breast.rightDuration = Int16(breastSession.rightDuration)
            breast.first = breastSession.first.rawValue
            activityDate.addToActivity(breast)

        case .sleep(duration: let duration):
            let sleep = Sleep(context: context)
            sleep.duration = Int16(duration)
            activityDate.addToActivity(sleep)

        case .growth(weight: let weight, height: let height, headCircumference: let headCircumference):
            let growth = Growth(context: context)
            growth.weight = Int16(weight)
            growth.height = Int16(height)
            growth.headCircumfeence = Int16(headCircumference)
            activityDate.addToActivity(growth)

        case .solide(composition: let composition):
            let solid = Solid(context: context)
            solid.vegetable = Int16(composition.vegetable)
            solid.meat = Int16(composition.meat)
            solid.fruit = Int16(composition.fruit)
            solid.dairyProduct = Int16(composition.dairyProduct)
            solid.cereal = Int16(composition.cereal)
            solid.other = Int16(composition.other)
            activityDate.addToActivity(solid)
        }
        coreDataManager.save()
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
