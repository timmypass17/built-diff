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
    @Environment(\.childContext) private var childContext   // important: need environment to correctly show list of exercises
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State private var showExitAlert = false
    @State private var showIncompleteAlert = false
    @State var workout: WorkoutWrapper
    @State var isPresentingReviewSheet = false
    @State var isPresentingSuccessAlert = false

    var didFinishWorkout: Bool {
        workout.exercises.allSatisfy { $0.sets.allSatisfy { $0.isComplete } }
    }

    var body: some View {
        List {
            Section {
                ForEach(workout.exercises, id: \.name) { exercise in
                    NavigationLink(value: exercise) {
                        ExerciseCellView(exercise: exercise)
                    }
                }
            }
            
            Section {
                Button("Review") {
                    isPresentingReviewSheet.toggle()
                }
                .foregroundColor(.white.opacity(didFinishWorkout ? 1 : 0.6))
            }

        }
        .navigationTitle(workout.title)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: ExerciseWrapper.self) { exercise in
            ExerciseDetailView(exercise: exercise)
                .environment(appState)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showExitAlert = true
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .alert("Exit now?", isPresented: $showExitAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Leave", role: .destructive) {
                dismiss()
            }
        }, message: {
            Text("Your workout progress will be lost.")
        })
        .alert("Finish Workout?", isPresented: $showIncompleteAlert, actions: {
            Button("Cancel", role: .cancel) {}
            
            NavigationLink(value: workout) {
                Text("Continue")
            }
            .tint(.blue)
        }, message: {
            Text("You have unfinished sets.")
        })
        .fullScreenCover(isPresented: $isPresentingReviewSheet) {
            WorkoutConfirmationView(workout: workout, isPresentingSuccessAlert: $isPresentingSuccessAlert)
        }
        .alert("Workout Saved!", isPresented: $isPresentingSuccessAlert, actions: {
            Button("Got it", role: .cancel) {
                dismiss()
            }
        }, message: {
            Text("Your workout has been successfully recorded.")
        })
    }
}

struct ChildContextKey: EnvironmentKey {
    static let defaultValue: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

extension EnvironmentValues {
    var childContext: NSManagedObjectContext {
        get {
            return self[ChildContextKey.self]
        }
        set {
            self[ChildContextKey.self] = newValue
        }
    }
}

//#Preview {
//    WorkoutDetailView(template: <#Template#>)
//}
