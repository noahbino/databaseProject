//
//  ExerciseVC.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/26/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit
import Foundation

class WorkoutVC: UIViewController, UpdateDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var alert:ExerciseVC = ExerciseVC()
    var timer = Timer()
    var workoutTimer = Timer()
    var currentWorkout:Workout?
    var minutes = 0
    var dateString:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        WorkoutService.instance.exercises.removeAll()

        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let date = Date()
        dateString = dateFormatter.string(from: date)
        
        

        alert.delegate = self
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        workoutTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(workoutTimerAction), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func timerAction() {
        tableView.reloadData()
    }
    
    @objc func workoutTimerAction(){
        minutes += 1
    }
    
    @IBAction func newPressed(_ sender: Any) {
        
    }
    

    @IBAction func homePressed(_ sender: Any) {
        dismissDetail()

    }
    
    func updateExerciseCells() {
        //update table
        
    }
    
    @IBAction func saveWorkoutPressed(_ sender: Any) {
        if(!WorkoutService.instance.exercises.isEmpty){
            currentWorkout = Workout(exercises: WorkoutService.instance.exercises, date: dateString!, length: String(minutes))
            WorkoutService.instance.workouts.append(currentWorkout!)
            dismissDetail()
        }
        
    }
    
    

}
extension WorkoutVC: UITableViewDataSource, UITableViewDelegate {
    
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
        
        cell.difficultyLabel.text = "Difficulty: " + exercise.difficulty
        cell.exerciseNameLabel.text = exercise.name
        cell.numberOfSetsLabel.text = "Sets: " + exercise.sets
        cell.repsLabel.text = "Reps: " + exercise.reps
        cell.weightLabel.text = "Weight: " + exercise.weight
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            WorkoutService.instance.exercises.remove(at: indexPath.item)
            tableView.reloadData()
        }
    }
    
    
    
    
}


