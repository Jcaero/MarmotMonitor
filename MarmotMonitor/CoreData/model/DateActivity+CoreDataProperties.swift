//
//  DateActivity+CoreDataProperties.swift
//  MarmotMonitor
//
//  Created by pierrick viret on 07/01/2024.
//
//

import Foundation
import CoreData

extension DateActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateActivity> {
        return NSFetchRequest<DateActivity>(entityName: "DateActivity")
    }

    @NSManaged public var date: Date
    @NSManaged public var activity: NSSet?

    public var activityArray: [Activity] {
        let set = activity as? Set<Activity> ?? []
        return set.sorted { _,_ in date > date }
    }
}

// MARK: Generated accessors for activity
extension DateActivity {

    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: Activity)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: Activity)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

}

extension DateActivity : Identifiable {

}
