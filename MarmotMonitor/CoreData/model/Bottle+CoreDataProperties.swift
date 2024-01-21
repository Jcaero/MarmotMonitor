//
//  Bottle+CoreDataProperties.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
//

import Foundation
import CoreData

extension Bottle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bottle> {
        return NSFetchRequest<Bottle>(entityName: "Bottle")
    }

    @NSManaged public var quantity: Int16

    public var intQuantity: Int {
        return Int(quantity)
    }

}
