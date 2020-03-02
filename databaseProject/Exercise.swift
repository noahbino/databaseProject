//
//  Exercise.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/27/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation

class Exercise {

    var name: String
    var weight: String
    var reps: String
    var sets: String
    var difficulty: String
    
    init(name: String, weight: String, reps: String, sets: String, difficulty: String) {
        self.name = name
        self.weight = weight
        self.reps = reps
        self.sets = sets
        self.difficulty = difficulty
    }
    
}
