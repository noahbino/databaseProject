//
//  Workouts.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/29/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation

class WorkoutService {
    
    static let instance = WorkoutService()
    
    var workouts = [Workout]()
    var exercises = [Exercise]()
    var currentWorkout = Workout()
    var exerciseList = [Exercise]()
    var currentExercise = Exercise(name: "")
    var addedExercises = [Exercise]()
    var isEditMode = false
    
}
