//
//  WorkoutDetailViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/7/25.
//

import Foundation

@Observable class WorkoutDetailViewModel {
    var workout: WorkoutWrapper
    var template: Template
    var showExitAlert = false
    var showIncompleteAlert = false
    var isPresentingSuccessAlert = false
    var isPresentingConfirmationSheet = false
    var isPresentingOptionsSheet = false

    var didFinishWorkout: Bool {
        workout.exercises.allSatisfy { $0.sets.allSatisfy { $0.isComplete } }
    }
    
    init(template: Template, weightUnit: WeightType) {
        workout = WorkoutWrapper(template: template, weightUnit: weightUnit)
        self.template = template
    }
    
//    init(workout: WorkoutWrapper) {
//        print("WorkoutDetailViewModel init")
//        self.workout = workout
//    }
//    
    func saveWorkout(weightType: WeightType) {
        _ = Workout(workoutWrapper: workout, weightUnit: weightType, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.saveContext()
        isPresentingSuccessAlert.toggle()
    }
}
