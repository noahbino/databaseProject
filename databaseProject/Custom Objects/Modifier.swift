//
//  Modifier.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/7/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation

class Modifier {
    var name: String
    var modType: String?
    var modifierKey: String?
    
    init(name: String, modType: String?) {
        self.name = name
        self.modType = modType

    }
}
