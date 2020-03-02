//
//  Workout.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/27/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation

class Workout {
    
    var exercises:[Exercise]
    var date: String
    var length: String
    
    init(exercises: [Exercise], date: String, length: String) {
        self.exercises = exercises
        self.date = date
        self.length = length
    }
}
