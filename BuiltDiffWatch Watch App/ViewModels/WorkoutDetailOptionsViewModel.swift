//
//  WorkoutDetailOptionsViewModel.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/14/25.
//

import Foundation

@Observable class WorkoutDetailOptionsViewModel {
    var workout: WorkoutWrapper
    var template: Template
    var isPresentingListView = false
    var isPresentingDeleteAlert = false
    var isPresentingDeleteSuccessAlert = false
    let workoutService = WorkoutDao(context: CoreDataStack.shared.mainContext, backgroundContext: CoreDataStack.shared.mainContext)
    
    init(workout: WorkoutWrapper, template: Template) {
        self.workout = workout
        self.template = template
    }
    
    func deleteTemplate() async {
        do {
            try await workoutService.deleteTemplate(template)
            let templates: [Template] = try await workoutService.fetchTemplates()
            
            for (i, temp) in templates.enumerated() {
                temp.index = Int16(i)
            }
            CoreDataStack.shared.saveContext()
        } catch {
            print("Failed to delete template: \(error)")
        }
    }
}
