//
//  ExerciseVC.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/29/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit
import Foundation
import Firebase


protocol UpdateDelegate {
    func updateExerciseCells()
}

class ExerciseVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!

    @IBOutlet weak var saveWorkoutButton: startNewExerciseButtonExtension!
        
    @IBOutlet weak var barPickerView: UIPickerView!
    @IBOutlet weak var kitPickerView: UIPickerView!
    @IBOutlet weak var gripPickerView: UIPickerView!
    @IBOutlet weak var romPickerView: UIPickerView!
    
    @IBOutlet weak var setsStepper: UIStepper!
    
    
    
    var delegate:UpdateDelegate?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var setsArray = [ExerciseSet]()
    var exercise:Exercise?
    var difficulty:String?
    var slid = false
    var exerciseToSave: Exercise?
    var barModifierArray = [Modifier(name: "none", modType: "none")]
    var kitModifierArray = [Modifier(name: "none", modType: "none")]
    var ROMModifierArray = [Modifier(name: "none", modType: "none")]
    var gripModifierArray = [Modifier(name: "none", modType: "none")]
  
    var indexPath: IndexPath?
    var indexPathRow = 0
    var emptyField = false
    
    var exerciseToAdd = Exercise(name: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        
        exerciseNameLabel.text = exercise?.name

    }
    
    func initExercise(exercise: Exercise){
        self.exercise = exercise
    }
    
    @IBAction func setsStepper(_ sender: UIStepper) {
        
        
        if(setsArray.count <= Int(sender.value)){
            setsArray.append(ExerciseSet(weight: "", reps: "", RPE: "", setID: ""))
        } else {
            setsArray.remove(at: setsArray.count - 1)
        }
        tableView.reloadData()
        setsLabel.text = "Sets (\(setsArray.count))"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //set variables
    
        if(pickerView.tag == 1){
            let mod = Modifier(name: barModifierArray[row].name, modType: "bar")
            exerciseToAdd.modifiers.append(mod)
        } else if(pickerView.tag == 2){
            let mod = Modifier(name: kitModifierArray[row].name, modType: "kit")
            exerciseToAdd.modifiers.append(mod)
            
        } else if(pickerView.tag == 3){
            let mod = Modifier(name: gripModifierArray[row].name, modType: "grip")
            exerciseToAdd.modifiers.append(mod)
        } else if(pickerView.tag == 4){
            let mod = Modifier(name: ROMModifierArray[row].name, modType: "ROM")
            exerciseToAdd.modifiers.append(mod)
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 1){
            for mod in exercise!.modifiers {
                if(mod.modType == "bar"){
                    barModifierArray.append(mod)
                }
            }
            return barModifierArray[row].name
            
        } else if(pickerView.tag == 2){
            for mod in exercise!.modifiers {
                if(mod.modType == "kit"){
                    kitModifierArray.append(mod)
                }
            }
            return kitModifierArray[row].name
            
        } else if(pickerView.tag == 3) {
            for mod in exercise!.modifiers {
                if(mod.modType == "grip"){
                    gripModifierArray.append(mod)
                }
            }
            return gripModifierArray[row].name
            
        } else if(pickerView.tag == 4){
            for mod in exercise!.modifiers {
                if(mod.modType == "ROM"){
                    ROMModifierArray.append(mod)
                }
            }
            return ROMModifierArray[row].name
        }
        
        return nil
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return barModifierArray.count
            
        } else if(pickerView.tag == 2){
            return kitModifierArray.count
            
        } else if(pickerView.tag == 3) {
            return gripModifierArray.count
            
        } else if(pickerView.tag == 4){
            return ROMModifierArray.count
        }
        return 1
    }
    
    
    
    
    @IBAction func saveWorkoutPressed(_ sender: Any) {

        getTableData()
        
        
        if(!emptyField && !setsArray.isEmpty && !WorkoutService.instance.isEditMode){
            exerciseToAdd.name = exercise?.name as! String
            exerciseToAdd.setsObject = setsArray
            WorkoutService.instance.exercises.append(exerciseToAdd)
            self.delegate?.updateExerciseCells()
            DataService.instance.updateSession()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else if(!emptyField && !setsArray.isEmpty && WorkoutService.instance.isEditMode){
            exerciseToAdd.name = exercise?.name as! String
            exerciseToAdd.setsObject = setsArray
            WorkoutService.instance.exercises.append(exerciseToAdd)
            for set in setsArray {
                DataService.instance.addSet(toWorkout: WorkoutService.instance.currentWorkout, setToAdd: set, modifiers: exerciseToAdd.modifiers)
            }
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "You Missed A Spot!", message: "You need to enter in all information for all sets", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            emptyField = false
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getTableData(){
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! SetCell
            let set = ExerciseSet(weight: cell.weightInput.text!, reps: cell.repsInput.text!, RPE: cell.RPE, setID: "")
            set.setIndex = (i + 1)
            if(set.reps == "" || set.weight == ""){
                self.emptyField = true
            }
            self.setsArray[i] = set
        }
    }
   
    


}
extension ExerciseVC: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "setCell") as? SetCell else {return UITableViewCell()}
        
        cell.setCounterLabel.text = "\(indexPath.row + 1)"
        cell.repsInput.delegate = self
        cell.weightInput.delegate = self
        
        

        
        return cell
    }
    
    
    
}
