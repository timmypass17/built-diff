//
//  AddWorkoutViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import Foundation

@Observable class AddWorkoutViewModel {
    var template: TemplateWrapper
    var isPresentingAddExerciseSheet = false
    var isPresentingSuccessAlert = false
    
    init(template: TemplateWrapper) {
        self.template = template
    }
    
    func saveTemplate() {
        _ = Template(templateWrapper: template, context: CoreDataStack.shared.mainContext)
        CoreDataStack.shared.saveContext()
        isPresentingSuccessAlert.toggle()
    }
}
