//
//  ExerciseVC.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/26/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class WorkoutVC: UIViewController, UpdateDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var notesInput: NotesTextViewExtension!
    @IBOutlet weak var saveWorkoutButton: startNewExerciseButtonExtension!
    
    var workoutTimer = Timer()
    var currentWorkout:Workout?
    var minutes = 0
    var dateString:String?
    var startTime = ""
    var endTime = ""
    
    
    


    override func viewDidLoad() {
                
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        notesInput.delegate = self
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let date = Date()
        dateString = dateFormatter.string(from: date)
        WorkoutService.instance.addedExercises.removeAll()
        
        workoutTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(workoutTimerAction), userInfo: nil, repeats: true)
        
        //get start time
        
        startTime = HelperFunctions.instance.getTime()
        
        if(WorkoutService.instance.isEditMode){
            WorkoutService.instance.exercises = WorkoutService.instance.currentWorkout.exercises!
            self.notesInput.text = WorkoutService.instance.currentWorkout.notes
            saveWorkoutButton.isHidden = true
        }
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExerciseVC {
            vc.delegate = self
        }
    }
    
    
    
    @objc func workoutTimerAction(){
        minutes += 1
    }
    
    

    @IBAction func homePressed(_ sender: Any) {
        
        WorkoutService.instance.currentWorkout.notes = notesInput.text
        DataService.instance.updateSession()
        
        
        dismissDetail()
    }
    
    func updateExerciseCells() {
        tableView.reloadData()
    }
    
    @IBAction func saveWorkoutPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Save and Exit?", message: "would you like to save an exit or return to your session", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save & Exit", style: .default, handler: { (action) in
            
            if(!WorkoutService.instance.isEditMode){
                let sessionToAdd = Workout()
                sessionToAdd.exercises = WorkoutService.instance.exercises
                if(self.notesInput.text != "" && self.notesInput.text != "Notes go here..."){
                    sessionToAdd.notes = self.notesInput.text
                } else {
                    sessionToAdd.notes = "none"
                }
                    sessionToAdd.startTime = self.startTime
                    sessionToAdd.endTime = HelperFunctions.instance.getTime()
                
                    sessionToAdd.date = HelperFunctions.instance.getDate()
                
                    var rpe = 0.0
                    var totalSets = 0.0
                    for exercise in sessionToAdd.exercises! {
                        for setsObject in exercise.setsObject! {
                            rpe += Double(setsObject.RPE!)!
                            totalSets += 1
                        }
                    }
                    sessionToAdd.sessionRPE = String(Double(rpe / totalSets))

                      
                    DataService.instance.uploadSession(uid: Auth.auth().currentUser!.uid, session: sessionToAdd)
                    WorkoutService.instance.exercises.removeAll()
                    self.dismiss(animated: true, completion: nil)
            } else if(WorkoutService.instance.isEditMode){
                WorkoutService.instance.currentWorkout.notes = self.notesInput.text
                DataService.instance.updateSession()
                self.dismiss(animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Return to session", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    

}
extension WorkoutVC: UITableViewDataSource, UITableViewDelegate, UIAdaptivePresentationControllerDelegate, UITextViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return WorkoutService.instance.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell") as? ExerciseCell else {return UITableViewCell()}
        
        let x = WorkoutService.instance.exercises
        let exercise = x[indexPath.row]
        
        cell.exerciseNameLabel.text = exercise.name
        var weight = 0
        var rpe = 0.0
        var reps = 0
        var work = 0
        for setObject in exercise.setsObject! {
            weight += Int(setObject.weight!)!
            rpe += Double(setObject.RPE!)!
            reps += Int(setObject.reps!)!
            work += Int(setObject.weight!)! * Int(setObject.reps!)!
        }
        rpe = rpe / Double(exercise.setsObject!.count)
        cell.difficultyLabel.text = "Average RPE: \(rpe)"
        cell.repsLabel.text = "Total Reps: \(reps)"
        cell.numberOfSetsLabel.text = "Total Sets: \(exercise.setsObject!.count)"
        cell.totalWorkLabel.text = "Total Work: \(work) units"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let alert = UIAlertController(title: "Delete this Exercise?", message: "This action cannot be un-done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                
                DataService.instance.deleteExercise(exercise: WorkoutService.instance.exercises[indexPath.item])
                WorkoutService.instance.exercises.remove(at: indexPath.item)
                WorkoutService.instance.currentWorkout.exercises = WorkoutService.instance.exercises
                DataService.instance.updateSession()
                tableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }

    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.tableView.reloadData()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(self.notesInput.text == "Notes go here..."){
            self.notesInput.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        WorkoutService.instance.currentWorkout.notes = textView.text
        DataService.instance.updateSession()
    }
    
}


