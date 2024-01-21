//
//  Breast+CoreDataProperties.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
//

import Foundation
import CoreData

extension Breast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breast> {
        return NSFetchRequest<Breast>(entityName: "Breast")
    }

    @NSManaged public var leftDuration: Int16
    @NSManaged public var rightDuration: Int16

    public var totalDuration: Int {
        let total = leftDuration + rightDuration
        return Int(total)
    }

}
