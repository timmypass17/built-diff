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
}
