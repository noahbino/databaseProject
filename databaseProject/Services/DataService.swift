//
//  DataService.swift
//  databaseProject
//
//  Created by Noah Iarrobino on 4/8/20.
//  Copyright © 2020 Noah Iarrobino. All rights reserved.
//

import Foundation
import Firebase
import CoreData

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    var REF_BASE = DB_BASE
    var REF_EXERCISES = DB_BASE.child("exercises")
    var REF_MODS = DB_BASE.child("modifiers")
    var REF_SESSIONS = DB_BASE.child("sessions")
    var REF_USERS = DB_BASE.child("users")
    var REF_SETS = DB_BASE.child("sets")
    
    

    func getAllExercises(){
        
        var modsArray = [Modifier]()
        REF_MODS.observeSingleEvent(of: .value) { (modSnapshot) in
            guard let modSnapshot = modSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for mod in modSnapshot {
                let modifierType = mod.childSnapshot(forPath: "type").value as! String
                let modToAdd = Modifier(name: mod.key, modType: modifierType)
                modsArray.append(modToAdd)
            }
            
            self.REF_EXERCISES.observeSingleEvent(of: .value) { (exerciseSnap) in
                guard let exerciseSnapshot = exerciseSnap.children.allObjects as? [DataSnapshot] else {return}
                
                WorkoutService.instance.exerciseList.removeAll()
                for exercise in exerciseSnapshot {
                    var modArray = [Modifier]()
                    
                    let name = exercise.key
                    
                    let mods = exercise.childSnapshot(forPath: "modifiers")
                    
                    guard let modSnap = mods.children.allObjects as? [DataSnapshot] else {return}

                    
                    for mod in modSnap {
                        let modValue = mod.value as! String
                        for modifier in modsArray {
                            
                            if(modValue == modifier.name){
                                modArray.append(Modifier(name: mod.value as! String, modType: modifier.modType))
                            }
                        }
                    }
                    let exerciseToAdd = Exercise(name: name)
                    exerciseToAdd.modifiers = modArray
                    WorkoutService.instance.exerciseList.append(exerciseToAdd)
                }
            }
        }
    }
    
    func getAllUserNames() -> [String]{
        var names = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (snap) in
            guard let snap = snap.children.allObjects as? [DataSnapshot] else {return}
            for name in snap {
                let theName = name.childSnapshot(forPath: "userName").value as! String
                names.append(theName)
            }
        }
        
        return names
    }
    
    func getCurrentUser(uid: String){
        
        REF_USERS.child(uid).child("userName").observeSingleEvent(of: .value) { (snap) in
            let userName = snap.value as? String
            CurrentUser.instance.userName = userName!
        }
    }
    
    func uploadSession(uid: String, session: Workout){
        
        var setDict = [String:Any]()
        var modDict = [String:Any]()
        var exerciseDict = [String:Any]()
        var modifiers = [String:Any]()
        var exercises = [String:Any]()
        var sets = [String:Any]()
        var exerciseKeys = [String]()
        var modifierNames = [String]()
    
        var exerciseCount = 1
        var setCount = 1
        var modCount = 1
        

        let cdWorkout = CDWorkout(context: context)
        
        let sessionKey = REF_SESSIONS.childByAutoId().key
        
        for exercise in session.exercises! {
            let cdExercise = CDExercise(context: context)
            
            
            
            modCount = 1
            for modifier in exercise.modifiers {
                let cdMod = CDModifier(context: context)
                modDict = ["name" : modifier.name, "type" : modifier.modType!]
                modifiers["\(modCount)"] = modDict
                modCount += 1
                cdMod.name = modifier.name
                cdMod.type = modifier.modType
                cdExercise.addToModifiers(cdMod)
                modifierNames.append(modifier.name)
                
            }
            
            for set in exercise.setsObject! {
                let cdSet = CDSet(context: context)
                let setKey = REF_SETS.childByAutoId().key
                
                setDict = ["weight" : set.weight!, "reps" : set.reps!, "rpe" : set.RPE!, "setIndex" : "\(set.setIndex!)", "sessionID" : sessionKey!, "modifiers" : modifierNames, "userID" : Auth.auth().currentUser?.uid, "exerciseID" : exercise.name]
                cdSet.reps = set.reps
                cdSet.weight = set.weight
                cdSet.rpe = set.RPE
                cdSet.setID = setKey!
                
                
                cdExercise.addToSets(cdSet)
                
                REF_SETS.child(setKey!).updateChildValues(setDict)
                
                cdWorkout.addToSets(cdSet)
            }
            
            
            cdExercise.name = exercise.name
            cdWorkout.addToExercises(cdExercise)
            
        }
        
        
       
        
          
        cdWorkout.sessionKey = sessionKey!
        
        cdWorkout.notes = session.notes
        cdWorkout.startTime = session.startTime
        cdWorkout.endTime = session.endTime
        cdWorkout.rpe = session.sessionRPE
        cdWorkout.date = session.date!
        ad.saveContext()
        
        
  
        
        
        REF_SESSIONS.child(sessionKey!).updateChildValues(["start time" : session.startTime as Any, "end time" : session.endTime as Any, "notes" : session.notes!, "session RPE" : session.sessionRPE!, "date" : session.date!])
        
        
    }
    
    func fetchUserSessions(){
        WorkoutService.instance.workouts.removeAll()
        var fetchedWorkouts = [CDWorkout]()
        do {
            
            fetchedWorkouts = try context.fetch(CDWorkout.fetchRequest())
            
            for workout in fetchedWorkouts {
                let workoutToAdd = Workout()
                workoutToAdd.notes = workout.notes ?? "none"
                workoutToAdd.startTime = workout.startTime
                workoutToAdd.endTime = workout.endTime
                workoutToAdd.sessionRPE = workout.rpe
                workoutToAdd.date = workout.date
                workoutToAdd.sessionKey = workout.sessionKey!
                
                var exerciseArrayToAdd = [Exercise]()
                
                
                for exercise in (workout.exercises!.allObjects) as! [CDExercise] {
                    
                    var modArrayToAdd = [Modifier]()
                    for mod in exercise.modifiers?.allObjects as! [CDModifier] {
                        modArrayToAdd.append(Modifier(name: mod.name!, modType: mod.type!))
                    }
                    
                    var setArrayToAdd = [ExerciseSet]()
                    for sets in exercise.sets?.allObjects as! [CDSet] {
                        setArrayToAdd.append(ExerciseSet(weight: sets.weight!, reps: sets.reps!, RPE: sets.rpe!, setID: sets.setID ?? ""))
                    }
                    
                    
                    let exerciseToAdd = Exercise(name: exercise.name!)
                    exerciseToAdd.modifiers = modArrayToAdd
                    exerciseToAdd.setsObject = setArrayToAdd
                    exerciseArrayToAdd.append(exerciseToAdd)
                }
                workoutToAdd.exercises = exerciseArrayToAdd
                WorkoutService.instance.workouts.append(workoutToAdd)
            }
        } catch {
            
        }
        
        
    }
    
    func deleteSet(setID: String){
        
        do {
            
            let fetchedSets = try context.fetch(CDSet.fetchRequest()) as [CDSet]
            for exerciseSet in fetchedSets {
                if(exerciseSet.setID == setID){
                    context.delete(exerciseSet as NSManagedObject)
                    ad.saveContext()
                    break
                }
            }
        } catch {}
        
        REF_SETS.child(setID).removeValue()
        
    }
    
    func addSet(toWorkout workout: Workout, setToAdd: ExerciseSet, modifiers: [Modifier]){
        let setKey = REF_SETS.childByAutoId().key
        
        var modNames = [String]()
        for mod in modifiers {
            modNames.append(mod.name)
        }
        
        
        let setDict = ["reps" : setToAdd.reps!, "rpe" : setToAdd.RPE!, "sessionID" : workout.sessionKey!, "setIndex" : setToAdd.setIndex!, "weight" : setToAdd.weight!, "modifiers" : modNames, "userID" : Auth.auth().currentUser!.uid as Any]
        
        REF_SETS.child(setKey!).updateChildValues(setDict)
        do{
            let fetchedWorkout = try context.fetch(CDWorkout.fetchRequest()) as [CDWorkout]
            
            let cdExercise = CDExercise(context: context)
            
            for cdWorkout in fetchedWorkout {
                if(cdWorkout.sessionKey == workout.sessionKey){
                    
                   
                    
                    let cdSet = CDSet(context: context)
                    cdSet.weight = setToAdd.weight
                    cdSet.setID = setKey
                    cdSet.setIndex = String(describing: setToAdd.setIndex)
                    cdSet.rpe = setToAdd.RPE
                    cdSet.reps = setToAdd.reps
                    
                    cdWorkout.addToSets(cdSet)
                    for exercise in cdWorkout.exercises!.allObjects as! [CDExercise] {
                        if(exercise.name == WorkoutService.instance.currentExercise.name){
                            
                            exercise.addToSets(cdSet)
                            break
                        }
                    }
                    
                    ad.saveContext()
                }
            }
            
        } catch {}
        
    }
    
    
    func updateSession(){
        
        
        do {
            
            var fetchedWorkout = [CDWorkout]()
            
            fetchedWorkout = try context.fetch(CDWorkout.fetchRequest())
            
            for workout in fetchedWorkout {
                if(workout.sessionKey == WorkoutService.instance.currentWorkout.sessionKey){
                    for exercise in workout.exercises!.allObjects as! [CDExercise] {
                        context.delete(exercise as NSManagedObject)
                        ad.saveContext()
                    }
                   
                }
            }
            
            
            
            
            
            for workout in fetchedWorkout {
                
                if(workout.sessionKey == WorkoutService.instance.currentWorkout.sessionKey){
                    for exercise in WorkoutService.instance.exercises {
                        
                        var setDict = [String : Any]()
                        var modDict = [String : Any]()
                        
                        var modifiers = [String : Any]()
                        var set = [String : Any]()
                        
                        
                        let exerciseToAdd = CDExercise(context: context)
                        exerciseToAdd.name = exercise.name
                        
                        var modCount = 1
                        for mod in exercise.modifiers {
                            let cdMod = CDModifier(context: context)
                            cdMod.name = mod.name
                            cdMod.type = mod.modType
                            exerciseToAdd.addToModifiers(cdMod)
                            modDict = ["name" : mod.name, "type" : mod.modType!]
                            modifiers["\(modCount)"] = modDict
                            modCount += 1
                        }
                        
                        var setCount = 1
                        for sets in exercise.setsObject! {
                            let cdSet = CDSet(context: context)
                            cdSet.reps = sets.reps
                            cdSet.rpe = sets.RPE
                            cdSet.weight = sets.weight
                            cdSet.setID = sets.setKey
                            exerciseToAdd.addToSets(cdSet)
                            setDict = ["weight" : sets.weight!, "reps" : sets.reps!, "rpe" : sets.RPE!]
                            set["\(setCount)"] = setDict
                            setCount += 1
                        }
                        
                        
                        workout.addToExercises(exerciseToAdd)
                        ad.saveContext()
                        
                    }
                    REF_SESSIONS.child(WorkoutService.instance.currentWorkout.sessionKey!).updateChildValues(["notes":WorkoutService.instance.currentWorkout.notes!])
                    workout.notes = WorkoutService.instance.currentWorkout.notes
                    ad.saveContext()
                    
                }
                
            }
            
            
            
            
        } catch {}
        
        
    }
    

    func createDBUser(uid: String, userData: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    func deleteSession(workout: Workout){
        REF_SESSIONS.child(workout.sessionKey!).removeValue()
        
        
        REF_SETS.observeSingleEvent(of: .value) { (snap) in
            guard let setSnap = snap.children.allObjects as? [DataSnapshot] else {return}
            
            for set in setSnap {
                let sessionID = set.childSnapshot(forPath: "sessionID").value as! String
                if(sessionID == workout.sessionKey){
                    
                    self.REF_SETS.child(set.key).removeValue()
                }
            }
        }
        
        var fetchedWorkouts = [CDWorkout]()
        
        do {
            
            fetchedWorkouts = try context.fetch(CDWorkout.fetchRequest())
            for session in fetchedWorkouts {
                if(session.sessionKey == workout.sessionKey){
                    for set in session.sets?.allObjects as! [CDSet] {
                        context.delete(set as! NSManagedObject)
                    }
                    context.delete(session as! NSManagedObject)
                    ad.saveContext()
                    break
                }
            }
            
        } catch {}
        
    }
    
    
    func deleteExercise(exercise: Exercise){
        
        for sets in exercise.setsObject! {
            DataService.instance.deleteSet(setID: sets.setKey!)
        }
    }
    
    func deleteData(){
        
        var workout = [CDWorkout]()
        var exercise = [CDExercise]()
        var set = [CDSet]()
        var mod = [CDModifier]()
        
        do {
            
            workout = try context.fetch(CDWorkout.fetchRequest())
            exercise = try context.fetch(CDExercise.fetchRequest())
            set = try context.fetch(CDSet.fetchRequest())
            mod = try context.fetch(CDModifier.fetchRequest())
            
            for x in workout {
                context.delete(x as NSManagedObject)
                ad.saveContext()
            }
            for x in exercise {
                context.delete(x as NSManagedObject)
                ad.saveContext()
            }
            for x in set {
                context.delete(x as NSManagedObject)
                ad.saveContext()
            }
            for x in mod {
                context.delete(x as NSManagedObject)
                ad.saveContext()
            }
            
            
            
        } catch {
            
        }
        
        
    }
    
    
}
