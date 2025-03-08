//
//  WorkoutReviewViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/7/25.
//

import Foundation

@Observable class WorkoutReviewViewModel {
    let workout: WorkoutWrapper
    var isPresentingConfirmationSheet = false
    var isPresentingSuccessAlert = false
    
    init(workout: WorkoutWrapper) {
        print("WorkoutReviewViewModel init")
        self.workout = workout
    }
    
    func saveWorkout(weightType: WeightType) {
        _ = Workout(workoutWrapper: workout, weightUnit: weightType, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.saveContext()
        isPresentingSuccessAlert.toggle()
    }
}
