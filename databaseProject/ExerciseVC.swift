//
//  ExerciseVC.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/29/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit
import Foundation


protocol UpdateDelegate {
    func updateExerciseCells()
}

class ExerciseVC: UIViewController {

    
    
    @IBOutlet weak var exerciseNameInput: UITextField!
    
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var setsInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var difficultySlider: UISlider!
    @IBOutlet weak var saveWorkoutButton: startNewExerciseButtonExtension!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    
    var delegate:UpdateDelegate?
    
    var exercise:Exercise?
    var difficulty:String?
    var slid = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseNameInput.delegate = self
        weightInput.delegate = self
                
        exerciseNameInput.tag = 1
        weightInput.tag = 2
        
        saveWorkoutButton.isHidden = true

    }
    
    @IBAction func difficultySliderSlid(_ sender: UISlider) {
        if(exerciseNameInput.text != "" && weightInput.text != "" && setsInput.text != "" && repsInput.text != ""){
              saveWorkoutButton.isHidden = false
        
          } else {
              saveWorkoutButton.isHidden = true
          }
        
        
        difficultyLabel.text = String(round(sender.value*10)/10)
        difficulty = String(round(sender.value*10)/10)
        slid = true
        
        
    }
    
    
    
    @IBAction func saveWorkoutPressed(_ sender: Any) {
    
        exercise = Exercise(name: exerciseNameInput.text!, weight: weightInput.text!, reps: repsInput.text!, sets: setsInput.text!, difficulty: difficulty!)
        
        WorkoutService.instance.exercises.append(exercise!)
    

        self.delegate?.updateExerciseCells()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}
extension ExerciseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(exerciseNameInput.text != "" && weightInput.text != "" && setsInput.text != "" && repsInput.text != ""){
              saveWorkoutButton.isHidden = false
        
        } else if(weightInput.text != "" && setsInput.text != "" && repsInput.text != "" && slid){
              saveWorkoutButton.isHidden = false
        
        }else if(exerciseNameInput.text != "" && setsInput.text != "" && repsInput.text != "" && slid){
              saveWorkoutButton.isHidden = false
        
        } else if(weightInput.text != "" && exerciseNameInput.text != "" && repsInput.text != "" && slid){
              saveWorkoutButton.isHidden = false
        
        } else if(weightInput.text != "" && exerciseNameInput.text != "" && setsInput.text != "" && slid){
              saveWorkoutButton.isHidden = false
        
        } else if(weightInput.text != "" && exerciseNameInput.text != "" && repsInput.text != "" && slid){
              saveWorkoutButton.isHidden = false
        } 
        
    }
}
