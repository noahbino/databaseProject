//
//  ViewController.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/26/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit
import Firebase
import CoreData


class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchedWorkouts = [CDWorkout]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        WorkoutService.instance.exercises.removeAll()
        DataService.instance.getAllExercises()
        DataService.instance.fetchUserSessions()
        tableView.reloadData()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        DataService.instance.fetchUserSessions()
        tableView.reloadData()
        WorkoutService.instance.currentWorkout = Workout()
        WorkoutService.instance.isEditMode = false
    }
    
    
    @IBAction func startWorkoutPressed(_ sender: Any) {
        WorkoutService.instance.exercises.removeAll()
        goToExerciseVC()
    }
    
    
    
    func goToExerciseVC(){
        let vc = self.storyboard?.instantiateViewController(identifier: "WorkoutVC") as! WorkoutVC
        presentDetail(vc)
    }


}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return WorkoutService.instance.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as? WorkoutCell else {return UITableViewCell()}
        
        let x = WorkoutService.instance.workouts
        let workout = x[indexPath.row]
        
        let rpeDouble = Double(workout.sessionRPE!)
        
        let rpe = String(format: "%.1f", rpeDouble!)
        cell.averageRPELabel.text = "Average RPE: \(rpe)"
        cell.startTimeLabel.text = "\(workout.startTime!)"
        cell.endTimeLabel.text = "\(workout.endTime!)"
        cell.dateLabel.text = workout.date
        cell.numberOfExercisesLabel.text = "# of Exercises: \(workout.exercises!.count)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let alert = UIAlertController(title: "Delete this workout?", message: "This action cannot be un-done", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                DataService.instance.deleteSession(workout: WorkoutService.instance.workouts[indexPath.item])
                WorkoutService.instance.workouts.remove(at: indexPath.item)
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let workoutVC = storyboard?.instantiateViewController(identifier: "WorkoutVC") as? WorkoutVC else {return}
        
        
        let x = WorkoutService.instance.workouts
        WorkoutService.instance.currentWorkout = x[indexPath.row]
        
        WorkoutService.instance.isEditMode = true
        presentDetail(workoutVC)
        
    }

    
}
