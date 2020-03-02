//
//  ViewController.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 2/26/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        
        //load coredata
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @IBAction func startWorkoutPressed(_ sender: Any) {
        goToExerciseVC()
        
    }
    
    
    
    func goToExerciseVC(){
        let vc = self.storyboard?.instantiateViewController(identifier: "workoutVC") as! WorkoutVC
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
        
        cell.dateLabel.text = workout.date
        cell.lengthOfWorkoutLabel.text = "Length of workout: " + workout.length + "minutes"
        cell.numberOfExercisesLabel.text = "# of exercises: " + String(workout.exercises.count)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            WorkoutService.instance.workouts.remove(at: indexPath.item)
            tableView.reloadData()
        }
    }

    
}
