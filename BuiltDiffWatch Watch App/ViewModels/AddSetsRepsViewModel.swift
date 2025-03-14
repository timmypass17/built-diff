//
//  AddSetsRepsViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import Foundation

@Observable class AddSetsRepsViewModel {
    var exercise: TemplateExerciseWrapper
    
    init(exercise: TemplateExerciseWrapper) {
        self.exercise = exercise
    }
}
