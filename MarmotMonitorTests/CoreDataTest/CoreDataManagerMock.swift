//
//  testCoreDataStack.swift
//  MarmotMonitorTests
//
//  Created by pierrick viret on 15/01/2024.
//
import CoreData
@testable import MarmotMonitor

class CoreDataManagerMock: CoreDataManagerProtocol {
    
    // MARK: - Singleton
    
    static let sharedInstance = CoreDataManagerMock()
    
    // MARK: - INIT
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "MarmotMonitor")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Properties
    
    lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.newBackgroundContext()
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContext.automaticallyMergesChangesFromParent = true
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
