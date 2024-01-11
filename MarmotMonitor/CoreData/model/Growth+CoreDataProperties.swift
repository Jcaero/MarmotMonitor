//
//  Growth+CoreDataProperties.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
//

import Foundation
import CoreData

extension Growth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Growth> {
        return NSFetchRequest<Growth>(entityName: "Growth")
    }

    @NSManaged public var headCircumfeence: Int16
    @NSManaged public var height: Int16
    @NSManaged public var weight: Int16

}
