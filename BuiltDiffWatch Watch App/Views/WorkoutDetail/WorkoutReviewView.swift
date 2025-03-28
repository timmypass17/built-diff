//
//  WorkoutReviewView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/5/25.
//

import SwiftUI

struct WorkoutReviewView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State var workoutReviewViewModel: WorkoutReviewViewModel

    var body: some View {
        List {
            ForEach(workoutReviewViewModel.workout.exercises) { exercise in
                // TOOD: local
                Section(exercise.name) {
                    ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, set in
                        WorkoutConfirmationCellView(index: index, set: set)
                    }
                }
            }
        }
        // TODO: Local
        .navigationTitle(workoutReviewViewModel.workout.title)
//        .navigationTitle(translation[workoutReviewViewModel.workout.title] ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WorkoutReviewView(workoutReviewViewModel: WorkoutReviewViewModel(workout: WorkoutWrapper.samples[0]))
            .environment(AppState())
    }
}
