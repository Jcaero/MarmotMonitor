//
//  MarmotMonitorSaveManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
import CoreData
import UIKit

protocol MarmotMonitorSaveManagerProtocol {
    func saveDiaper(_ state: String, date: Date)
    func saveBottle(_ quantity: Int, date: Date)
    func fetchDiapers() -> [Diaper]
    func testDiaperFetch() -> [Diaper]
    func fetchDateActivities() -> [DateActivity]
    func saveDate(date: Date)
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
    func saveDate(date: Date) {
        let activityDate = DateActivity(context: context)
        activityDate.date = date

        coreDataManager.save()
    }

    func saveDiaper(_ state: String, date: Date) {
        let activityDate = DateActivity(context: context)
        activityDate.date = date

        let diaper = Diaper(context: context)
        diaper.state = state

        activityDate.addToActivity(diaper)
        coreDataManager.save()
    }

    func saveBottle(_ quantity: Int, date: Date) {
        let activityDate = DateActivity(context: context)
        activityDate.date = date

        let bottle = Bottle(context: context)
        bottle.quantity = Int16(quantity)

        activityDate.addToActivity(bottle)
        coreDataManager.save()
    }

    // MARK: - Fetch
    private func fetchActivities<T: Activity>(ofType type: T.Type, in context: NSManagedObjectContext) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("Erreur lors de la récupération des activités: \(error)")
            return []
        }
    }

    func testDiaperFetch() -> [Diaper] {
        do {
            return try context.fetch(Diaper.fetchRequest())
        } catch {
            print("Erreur lors de la récupération des activités: \(error)")
            return []
        }
    }

    func fetchDiapers() -> [Diaper] {
        return fetchActivities(ofType: Diaper.self, in: context)
    }

    func fetchDateActivities() -> [DateActivity] {
        let request = NSFetchRequest<DateActivity>(entityName: "DateActivity")
        // range les dates par ordre décroissant
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        // test predicate
        // get the current calendar
        let calendar = Calendar.current
        // get the start of the day of the selected date
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        // get the start of the day after the selected date
        let endDate = calendar.startOfDay(for: Date())
        // create a predicate to filter between start date and end date
        let predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        request.predicate = predicate

        do {
            let results = try context.fetch(request)
            // enleve les dates sans activités
            return results.filter { $0.activityArray.isEmpty == false }
        } catch {
            print("Erreur lors de la récupération des activités: \(error)")
            return []
        }
    }
}

//
//    return dateActivities.map { dateActivity in
//        let diapers = dateActivity.activityArray.compactMap { $0 as? Diaper }
//        let bottles = dateActivity.activityArray.compactMap { $0 as? Bottle }
//        return (dateActivity, diapers, bottles)
//    }
