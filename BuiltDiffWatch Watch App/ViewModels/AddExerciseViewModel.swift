//
//  AddExerciseViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import Foundation

@Observable class AddExerciseViewModel {
    var sections: [Section] = []
    var exercises: [String] = []
    var searchText = ""
    let workoutService: WorkoutService
    var isPresentingSetRepView = false
    var selectedExercise: TemplateExerciseWrapper? = nil
    var selectedExerciseName = ""
    var exerciseIndex: Int
    var template: TemplateWrapper
    
    struct Section {
        let letter: String
        let exercises: [String]
    }
    
    init(template: TemplateWrapper) {
        self.template = template
        self.exerciseIndex = template.templateExercises.count
        self.workoutService = WorkoutService(workoutDao: WorkoutDao(context: CoreDataStack.shared.mainContext, backgroundContext: CoreDataStack.shared.newBackgroundContext()))
        exercises = workoutService.loadExercises(from: "exercises")
        sections = groupExercisesByFirstLetter(exercises)
    }
    
    private func groupExercisesByFirstLetter(_ exercises: [String]) -> [Section] {
        let groupedDictionary = Dictionary(grouping: exercises, by: { String($0.prefix(1)) })
        let sortedKeys = groupedDictionary.keys.sorted()
        return sortedKeys.map { Section(letter: $0, exercises: groupedDictionary[$0]!.sorted()) }
    }
    
    func filteredSections(searchText: String) -> [Section] {
        guard !searchText.isEmpty else { return sections }
        return sections.compactMap { section in
            let filteredExercises = section.exercises.filter { $0.localizedCaseInsensitiveContains(searchText) }
            return filteredExercises.isEmpty ? nil : Section(letter: section.letter, exercises: filteredExercises)
        }
    }
}
