//
//  WorkoutDetailViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/7/25.
//

import Foundation

@Observable class WorkoutDetailViewModel {
    var workout: WorkoutWrapper
    var showExitAlert = false
    var showIncompleteAlert = false
    var isPresentingReviewSheet = false
    var isPresentingSuccessAlert = false

    var didFinishWorkout: Bool {
        workout.exercises.allSatisfy { $0.sets.allSatisfy { $0.isComplete } }
    }
    
    init(workout: WorkoutWrapper) {
        print("WorkoutDetailViewModel init")
        self.workout = workout
    }
    
}
