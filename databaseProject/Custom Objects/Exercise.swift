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
    var open_closed: String?
    var upper_lower_full: String?
    var compound_isoloation: Int?
    var movement_pattern: String?
    var bilat_unilat: String?
    var pain: String?
    var setsObject: [ExerciseSet]?
    var modifiers = [Modifier]()
    var exerciseKey:String?
    
    init(name: String) {
        self.name = name
    }
}
