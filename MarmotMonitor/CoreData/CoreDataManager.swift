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
    func save()
    func clearDatabase()
}

class CoreDataManager: CoreDataManagerProtocol {

    // MARK: - Singleton
    static let sharedInstance = CoreDataManager()

    // MARK: - Properties

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MarmotMonitor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.viewContext
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return viewContext
    }()

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

    func clearDatabase() {
        let entities = persistentContainer.managedObjectModel.entities
        
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            
            fetchRequest.includesPropertyValues = false
            do {
                let items = try viewContext.fetch(fetchRequest) as! [NSManagedObject]
                for item in items {
                    viewContext.delete(item)
                }
            } catch let error as NSError {
                print("Erreur lors de la suppression des entités \(entity.name!): \(error), \(error.userInfo)")
            }
            viewContext.refreshAllObjects()
            save()
        }
    }
}
