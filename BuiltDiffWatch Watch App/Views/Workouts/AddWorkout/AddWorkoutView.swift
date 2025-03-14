//
//  AddWorkoutView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @State var addWorkoutViewModel: AddWorkoutViewModel
    
    var body: some View {
        List {
            Section("Title") {
                TextField("Workout Title", text: $addWorkoutViewModel.template.title, prompt: Text("Push Day"))
            }
            
            Section("Exercises") {
                ForEach(Array(addWorkoutViewModel.template.templateExercises.enumerated()), id: \.offset) { i, exercise in
                    HStack {
                        Text("\(i + 1)")
                            .foregroundStyle(.secondary)
                        Text(exercise.name)
                        Spacer()
                        Text("\(exercise.sets)x\(exercise.reps)")
                            .foregroundStyle(.secondary)
                    }
                }
                Button("Add Exercise") {
                    addWorkoutViewModel.isPresentingAddExerciseSheet.toggle()
                }
            }
            
            Section {
                Button("Save Workout") {
                    addWorkoutViewModel.saveTemplate()
                }
            }
        }
        .navigationTitle("Create Workout")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    addWorkoutViewModel.isPresentingExitAlert.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .fullScreenCover(isPresented: $addWorkoutViewModel.isPresentingAddExerciseSheet) {
            AddExerciseView(addExerciseViewModel: AddExerciseViewModel(template: addWorkoutViewModel.template))
                .environment(appState)
        }
        .alert("Workout Template Saved!", isPresented: $addWorkoutViewModel.isPresentingSuccessAlert, actions: {
            Button("Got it!", role: .cancel) {
                dismiss()
            }
        }, message: {
            Text("Your workout template is ready! Start your workouts and track your sets and reps.")
        })
        .alert("Exit now?", isPresented: $addWorkoutViewModel.isPresentingExitAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Leave", role: .destructive) {
                dismiss()
            }
        }, message: {
            Text("Your workout template will be discarded.")
        })
        
    }
}

//#Preview {
//    AddWorkoutView()
//}
