//
//  Set.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 3/10/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation

class ExerciseSet {
    var weight: String?
    var reps: String?
    var RPE: String?
    var setIndex:Int?
    var setKey:String?

    
    init(weight: String, reps: String, RPE: String, setID: String) {
        self.weight = weight
        self.reps = reps
        self.RPE = RPE
        self.setKey = setID
    }
}
