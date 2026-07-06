//
//  AddExerciseView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(AppState.self) private var appState
    @State var addExerciseViewModel: AddExerciseViewModel
    
    var body: some View {
        List {
            ForEach(addExerciseViewModel.filteredSections(searchText: addExerciseViewModel.searchText), id: \.letter) { section in
                Section(header: Text(section.letter)) {
                    ForEach(section.exercises, id: \.self) { exerciseName in
                        Button(exerciseName) {
                            addExerciseViewModel.selectedExercise = TemplateExerciseWrapper(
                                name: exerciseName,
                                sets: 4,
                                reps: 12,
                                index: addExerciseViewModel.exerciseIndex
                            )
                        }
                    }
                }
            }
        }
        .searchable(text: $addExerciseViewModel.searchText, prompt: "Search Exercises")
        .autocorrectionDisabled(true)
        .navigationTitle("Add Exercise")
        .fullScreenCover(item: $addExerciseViewModel.selectedExercise) { exercise in
            AddSetsRepsView(exercise: exercise) { _ in
                // TODO: did add exercise
                addExerciseViewModel.template.templateExercises.append(exercise)
            }
        }
    }
}

//
//#Preview {
//    AddExerciseview()
//}
