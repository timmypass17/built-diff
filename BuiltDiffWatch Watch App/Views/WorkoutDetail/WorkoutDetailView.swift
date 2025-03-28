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
    var didDeleteTemplate: (Template) -> ()

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
                Button("Finish") {
                    workoutDetailViewModel.isPresentingConfirmationSheet.toggle()
                }
                .foregroundColor(.white.opacity(workoutDetailViewModel.didFinishWorkout ? 1 : 0.6))
            }

        }
        // TODO: Local
        .navigationTitle(workoutDetailViewModel.workout.title)
//        .navigationTitle(translation[workoutDetailViewModel.workout.title] ?? "")
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: ExerciseWrapper.self) { exercise in
            ExerciseDetailView(exercise: exercise)
                .environment(appState)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    workoutDetailViewModel.isPresentingExitAlert.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    workoutDetailViewModel.isPresentingOptionsSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .alert("Finish Workout?", isPresented: $workoutDetailViewModel.isPresentingConfirmationSheet, actions: {
            Button("Save Workout") {
                workoutDetailViewModel.saveWorkout(weightType: appState.weightUnit)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("You can make changes later in app if needed.")
        })
        .alert("Workout Saved!", isPresented: $workoutDetailViewModel.isPresentingSuccessAlert, actions: {
            Button("Got it!", role: .cancel) {
                appState.navigationPath.removeLast(appState.navigationPath.count)
            }
        }, message: {
            Text("Your workout has been successfully recorded.")
        })
        .alert("Exit now?", isPresented: $workoutDetailViewModel.isPresentingExitAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Leave", role: .destructive) {
                dismiss()
            }
        }, message: {
            Text("Your workout progress will be lost.")
        })
        .fullScreenCover(isPresented: $workoutDetailViewModel.isPresentingOptionsSheet) {
            WorkoutDetailOptionsView(workoutDetailOptionsViewModel: WorkoutDetailOptionsViewModel(
                workout: workoutDetailViewModel.workout,
                template: workoutDetailViewModel.template)) { template in
                    didDeleteTemplate(template)
                }
        }
    }
}

//
//#Preview {
//    NavigationStack {
//        WorkoutDetailView(workoutDetailViewModel: WorkoutDetailViewModel(workout: WorkoutWrapper.samples[0]))
//            .environment(AppState())
//    }
//}
