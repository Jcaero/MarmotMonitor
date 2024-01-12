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
    func load(completion: (() -> Void)?)
    func save()
    func clearDatabase()
}

final class CoreDataManager: CoreDataManagerProtocol {

    // MARK: - Singleton

    static let sharedInstance = CoreDataManager(modelName: "MarmotMonitor")

    // MARK: - Propertie
    private let persistentContainer: NSPersistentContainer

    // MARK: - INIT
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError(error!.localizedDescription)}
            completion?()
        }
    }

    func save() {
        guard viewContext.hasChanges else {
            return
        }
        do {
            try self.viewContext.save()
        } catch {
            print("Error while saving: \(error.localizedDescription )")
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func clearDatabase() {
        let entities = persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try persistentContainer.viewContext.execute(deleteRequest)
            } catch let error as NSError {
                print("Erreur lors de la suppression des entités \(entity.name!): \(error), \(error.userInfo)")
            }
        }
        save()
    }
}
