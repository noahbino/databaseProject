//
//  HelperFunctions.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/24/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation

class HelperFunctions {
    
    static let instance = HelperFunctions()
    
    func getTime() -> String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: currentDateTime)
    }
    func getDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }
    
    
}
