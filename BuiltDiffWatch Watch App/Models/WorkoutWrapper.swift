//
//  WorkoutWrapper.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/4/25.
//

import Foundation
import CoreData

@Observable
class WorkoutWrapper {
    let id = UUID()
    var title: String
    var createdAt: Date
    var exercises: [ExerciseWrapper]
    var index: Int
    
    init(title: String, createdAt: Date, exercises: [ExerciseWrapper], index: Int) {
        self.title = title
        self.createdAt = createdAt
        self.exercises = exercises
        self.index = index
    }
    
    init(template: Template, weightUnit: WeightType) {
        print("Creating WorkoutWrapper")
        title = template.title
        createdAt = .now
        exercises = []
        index = 0   // TODO: Maybe data migraiton in future
        
        let previousWorkout = getPreviousWorkout(title: template.title)

        for templateExercise in template.templateExercises {
            let exercise = ExerciseWrapper(name: templateExercise.name, sets: [])
            
            let previousExercise = previousWorkout?.getExercises().first { $0.name == exercise.name }
            for i in 0..<templateExercise.sets {
                let set: SetWrapper
                if let previousExercise, previousExercise.getExerciseSets().count <= templateExercise.sets {
                    let previousSet = previousExercise.getExerciseSet(at: Int(i))
                    let previousWeight: Double
                    if weightUnit == .lbs {
                        // note: weight has to match picker (round if needed)
                        previousWeight = roundToNearest(previousSet.weight, increment: 2.5)
                    } else {
                        previousWeight = roundToNearest(previousSet.weight.lbsToKg, increment: 1.25)
                    }
                    set = SetWrapper(weight: previousWeight, reps: Int(templateExercise.reps), isComplete: false)
                } else {
                    set = SetWrapper(weight: weightUnit == .lbs ? 45 : 20, reps: Int(templateExercise.reps), isComplete: false)
                }
                exercise.sets.append(set)
            }
            
            exercises.append(exercise)
        }
    }
    
    private func getPreviousWorkout(title: String) -> Workout? {
        let context = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        let predicate = NSPredicate(format: "title_ == %@", title)
        let sortDescriptor = NSSortDescriptor(key: "createdAt_", ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        
        do {
            let workout: Workout? = try context.fetch(request).first
            return workout
        } catch {
            print("Error fetching previous workout: \(error.localizedDescription)")
        }
        return nil
    }
    
    
    private func roundToNearest(_ value: Double, increment: Double) -> Double {
        return (value / increment).rounded() * increment
    }
}

extension WorkoutWrapper: Hashable {
    static func == (lhs: WorkoutWrapper, rhs: WorkoutWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
