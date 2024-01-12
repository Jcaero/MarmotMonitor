//
//  CoreDataManagerMock.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 07/01/2024.
//

import UIKit
import CoreData

@testable import MarmotMonitor

class CoreDataManagerMock: CoreDataManagerProtocol {
    // MARK: - Singleton

    static let sharedInstance = CoreDataManager(modelName: "MarmotMonitor")

    // MARK: - Propertie
    private let persistentContainer: NSPersistentContainer

    // MARK: - INIT
    init(modelName: String) {

        persistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        print("init container")
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (_, error) in
            guard error == nil else { fatalError(error!.localizedDescription)}
            print("load container")
            completion?()
        }
    }

    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error while saving: \(error.localizedDescription )")
            }
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
