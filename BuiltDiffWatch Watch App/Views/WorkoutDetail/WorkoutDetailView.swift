//
//  WorkoutDetailView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI
import CoreData

// healthkit - active energy, workout effort score,workouts,
struct WorkoutDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State var workoutDetailViewModel: WorkoutDetailViewModel

    var body: some View {
        List {
            Section {
                ForEach(workoutDetailViewModel.workout.exercises) { exercise in
                    NavigationLink(value: exercise) {
                        ExerciseCellView(exercise: exercise)
                    }
                }
            }
            
            Section {
                Button("Review") {
                    workoutDetailViewModel.isPresentingReviewSheet.toggle()
                }
                .foregroundColor(.white.opacity(workoutDetailViewModel.didFinishWorkout ? 1 : 0.6))
            }

        }
        .navigationTitle(workoutDetailViewModel.workout.title)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: ExerciseWrapper.self) { exercise in
            ExerciseDetailView(exercise: exercise)
                .environment(appState)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    workoutDetailViewModel.showExitAlert.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .alert("Exit now?", isPresented: $workoutDetailViewModel.showExitAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Leave", role: .destructive) {
                dismiss()
            }
        }, message: {
            Text("Your workout progress will be lost.")
        })
        .fullScreenCover(isPresented: $workoutDetailViewModel.isPresentingReviewSheet) {
            WorkoutReviewView(
                workoutReviewViewModel: WorkoutReviewViewModel(workout: workoutDetailViewModel.workout)
            )
        }
    }
}


#Preview {
    NavigationStack {
        WorkoutDetailView(workoutDetailViewModel: WorkoutDetailViewModel(workout: WorkoutWrapper.samples[0]))
            .environment(AppState())
    }
}
