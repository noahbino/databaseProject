//
//  CDSet+CoreDataProperties.swift
//  
//
//  Created by Noah Iarrobino on 5/5/20.
//
//

import Foundation
import CoreData


extension CDSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSet> {
        return NSFetchRequest<CDSet>(entityName: "CDSet")
    }

    @NSManaged public var reps: String?
    @NSManaged public var rpe: String?
    @NSManaged public var weight: String?
    @NSManaged public var setID: String?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension CDSet {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: CDExercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: CDExercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}
