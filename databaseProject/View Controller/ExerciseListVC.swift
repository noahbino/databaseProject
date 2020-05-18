//
//  ExerciseListVC.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/1/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import UIKit

class ExerciseListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var exercises = WorkoutService.instance.exerciseList

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

 

}
extension ExerciseListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseListCell") as? ExerciseListCell else {return UITableViewCell()}

        let exercise = exercises[indexPath.row]
        
        cell.exerciseTitle.text = exercise.name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ExerciseVC = storyboard?.instantiateViewController(identifier: "ExerciseVC") as? ExerciseVC else {return}
        ExerciseVC.initExercise(exercise: exercises[indexPath.row])
        present(ExerciseVC, animated: true)
        
    }
    
    
}
