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
                Section(exercise.name) {
                    ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, set in
                        WorkoutConfirmationCellView(index: index, set: set)
                    }
                }
            }
            
            Section {
                Button {
                    workoutReviewViewModel.isPresentingConfirmationSheet.toggle()
                } label: {
                    Text("Finish Workout")
                }
            }
        }
        .navigationTitle(workoutReviewViewModel.workout.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Finish Workout?", isPresented: $workoutReviewViewModel.isPresentingConfirmationSheet, actions: {
            Button("Save Workout") {
                workoutReviewViewModel.saveWorkout(weightType: appState.weightUnit)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("You can make changes later in app if needed.")
        })
        .alert("Workout Saved!", isPresented: $workoutReviewViewModel.isPresentingSuccessAlert, actions: {
            Button("Got it!", role: .cancel) {
                appState.navigationPath.removeLast(appState.navigationPath.count)

            }
        }, message: {
            Text("Your workout has been successfully recorded.")
        })
    }
}

#Preview {
    NavigationStack {
        WorkoutReviewView(workoutReviewViewModel: WorkoutReviewViewModel(workout: WorkoutWrapper.samples[0]))
            .environment(AppState())
    }
}
