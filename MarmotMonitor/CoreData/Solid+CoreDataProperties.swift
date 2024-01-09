//
//  Solid+CoreDataProperties.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
//

import Foundation
import CoreData

extension Solid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Solid> {
        return NSFetchRequest<Solid>(entityName: "Solid")
    }

    @NSManaged public var cereal: Int16
    @NSManaged public var dairyProduct: Int16
    @NSManaged public var fruit: Int16
    @NSManaged public var meat: Int16
    @NSManaged public var other: Int16
    @NSManaged public var vegetable: Int16

}
