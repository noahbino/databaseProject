//
//  CDExercise+CoreDataProperties.swift
//  
//
//  Created by Noah Iarrobino on 5/5/20.
//
//

import Foundation
import CoreData


extension CDExercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExercise> {
        return NSFetchRequest<CDExercise>(entityName: "CDExercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var exerciseID: String?
    @NSManaged public var sets: NSSet?
    @NSManaged public var workouts: CDWorkout?
    @NSManaged public var modifier: NSSet?

}

// MARK: Generated accessors for sets
extension CDExercise {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: CDSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: CDSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

// MARK: Generated accessors for modifier
extension CDExercise {

    @objc(addModifierObject:)
    @NSManaged public func addToModifier(_ value: CDModifier)

    @objc(removeModifierObject:)
    @NSManaged public func removeFromModifier(_ value: CDModifier)

    @objc(addModifier:)
    @NSManaged public func addToModifier(_ values: NSSet)

    @objc(removeModifier:)
    @NSManaged public func removeFromModifier(_ values: NSSet)

}
