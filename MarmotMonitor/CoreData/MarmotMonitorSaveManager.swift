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

    func saveDiaper(_ state: String, date: Date) {
        let diaper = Diaper(context: context)
        diaper.state = state
        diaper.date = date
        coreDataManager.save()
    }

    func saveBottle(_ quantity: Int, date: Date) {
        let bottle = Bottle(context: context)
        bottle.quantity = Int16(quantity)
        bottle.date = date
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

    func fetchDiapers() -> [Diaper] {
        return fetchActivities(ofType: Diaper.self, in: context)
    }
}
