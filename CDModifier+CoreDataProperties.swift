//
//  CDModifier+CoreDataProperties.swift
//  
//
//  Created by Noah Iarrobino on 5/5/20.
//
//

import Foundation
import CoreData


extension CDModifier {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDModifier> {
        return NSFetchRequest<CDModifier>(entityName: "CDModifier")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var modifierID: String?
    @NSManaged public var exercise: NSSet?

}

// MARK: Generated accessors for exercise
extension CDModifier {

    @objc(addExerciseObject:)
    @NSManaged public func addToExercise(_ value: CDExercise)

    @objc(removeExerciseObject:)
    @NSManaged public func removeFromExercise(_ value: CDExercise)

    @objc(addExercise:)
    @NSManaged public func addToExercise(_ values: NSSet)

    @objc(removeExercise:)
    @NSManaged public func removeFromExercise(_ values: NSSet)

}
