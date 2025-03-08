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
    @Environment(\.childContext) private var childContext
    let workout: WorkoutWrapper
    @Binding var isPresentingSuccessAlert: Bool
    @State var isPresentingConfirmationSheet = false
    @Binding var navigationPath: NavigationPath  // Add binding

    var body: some View {
        List {
            ForEach(workout.exercises) { exercise in
                Section(exercise.name) {
                    ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, set in
                        WorkoutConfirmationCellView(index: index, set: set)
                    }
                }
            }
            
            Section {
                Button {
                    isPresentingConfirmationSheet.toggle()
                } label: {
                    Text("Finish Workout")
                }
            }
        }
        .navigationTitle(workout.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Finish Workout?", isPresented: $isPresentingConfirmationSheet, actions: {
            Button("Save Workout") {
                saveWorkout()
                isPresentingSuccessAlert = true
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("You can make changes later in app if needed.")
        })
        .alert("Workout Saved!", isPresented: $isPresentingSuccessAlert, actions: {
            Button("Got it!", role: .cancel) {
                navigationPath.removeLast(navigationPath.count)

            }
        }, message: {
            Text("Your workout has been successfully recorded.")
        })
    }
    
    func saveWorkout() {
        _ = Workout(workoutWrapper: workout, weightUnit: appState.weightUnit, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.saveContext()
    }
}

//#Preview {
//    WorkoutConfirmationView()
//}
