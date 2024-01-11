//
//  Diaper+CoreDataProperties.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
//

import Foundation
import CoreData

extension Diaper {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diaper> {
        return NSFetchRequest<Diaper>(entityName: "Diaper")
    }

    @NSManaged public var state: String?

    public var unwrappedState: String {
        state ?? "Unknown"
    }

}
