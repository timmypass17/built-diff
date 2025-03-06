//
//  WorkoutConfirmationView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/5/25.
//

import SwiftUI

struct WorkoutConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.childContext) private var childContext
    let workout: WorkoutWrapper
    @Binding var isPresentingSuccessAlert: Bool
    
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
                    saveWorkout()
                } label: {
                    Text("Finish Workout")
                }
            }
        }
        .navigationTitle(workout.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveWorkout() {
        _ = Workout(workoutWrapper: workout, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.saveContext()
        isPresentingSuccessAlert = true
        dismiss()
    }
}

//#Preview {
//    WorkoutConfirmationView()
//}
