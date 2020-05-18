
//
//  SetCell.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/10/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit



class SetCell: UITableViewCell {
    
    static let instance = SetCell()
    var weight: String?
    var reps: String?
    var RPE = "0"
    

    @IBOutlet weak var setCounterLabel: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var RPELabel: UILabel!
    @IBOutlet weak var RPESlider: UISlider!
    
    
    func doWork(){
        self.weight = weightInput.text
        self.reps = repsInput.text
        
    }
    
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        self.RPELabel.text = "RPE (\(String(round(sender.value*2)/2)))"
        self.RPE = String(round(sender.value*2)/2)
    }

}
