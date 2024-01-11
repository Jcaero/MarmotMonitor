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
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error while saving: \(error.localizedDescription )")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
//        return persistentContainer.viewContext
    }
}
