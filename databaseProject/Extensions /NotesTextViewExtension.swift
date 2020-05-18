//
//  NotesTextViewExtension.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/25/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit

class NotesTextViewExtension: UITextView {

    override func awakeFromNib() {
        self.layer.borderWidth = 1.0
        self.layer.opacity = 0.9
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
    }

}
