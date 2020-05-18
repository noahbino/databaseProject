//
//  CDWorkout+CoreDataProperties.swift
//  
//
//  Created by Noah Iarrobino on 5/5/20.
//
//

import Foundation
import CoreData


extension CDWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWorkout> {
        return NSFetchRequest<CDWorkout>(entityName: "CDWorkout")
    }

    @NSManaged public var date: String?
    @NSManaged public var endTime: String?
    @NSManaged public var notes: String?
    @NSManaged public var sessionKey: String?
    @NSManaged public var startTime: String?
    @NSManaged public var rpe: String?
    @NSManaged public var userKey: String?
    @NSManaged public var workoutID: String?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension CDWorkout {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: CDExercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: CDExercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}
