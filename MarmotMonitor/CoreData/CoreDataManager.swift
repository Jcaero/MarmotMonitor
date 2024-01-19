//
//  CoreDataManager.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func save() throws
    func clearDatabase()
}

class CoreDataManager: CoreDataManagerProtocol {

    // MARK: - Singleton
    static let sharedInstance = CoreDataManager()

    // MARK: - Properties

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MarmotMonitor")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.newBackgroundContext()
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
        return viewContext
    }()

    func save() throws {
        guard viewContext.hasChanges else {
            return
        }
        try viewContext.save()
    }

    func clearDatabase() {
        let entities = persistentContainer.managedObjectModel.entities

        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)

            fetchRequest.includesPropertyValues = false
            do {
                let items = try viewContext.fetch(fetchRequest)
                if let managedObjects = items as? [NSManagedObject] {
                    for item in managedObjects {
                        viewContext.delete(item)
                    }
                }
            } catch let error as NSError {
                print("Erreur lors de la suppression des entités \(entity.name!): \(error), \(error.userInfo)")
            }
            viewContext.refreshAllObjects()

            do {
                try save()
            } catch {
                print("Error while saving: \(error.localizedDescription)")
            }
        }
    }
}
