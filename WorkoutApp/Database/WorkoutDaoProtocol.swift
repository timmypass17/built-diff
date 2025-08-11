//
//  WorkoutDaoProtocol.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/14/25.
//

import Foundation
import CoreData

protocol WorkoutDaoProtocol {
    func createTemplate(context: NSManagedObjectContext) -> Template
    func createWorkout(template: Template, childContext: NSManagedObjectContext) -> Workout
    func fetchTemplates() async throws -> [Template]
    func fetchLogs(from startDate: Date?, to endDate: Date?) async throws -> [Workout]
    func fetchExerciseNames() async throws -> [String]
    func fetchExerciseSets(exerciseName: String, limit: Int?, ascending: Bool) async throws -> [ExerciseSet]
    func fetchPR(exerciseName: String) async throws -> Double
    func deleteTemplate(_ template: Template)
    func deleteLog(_ log: Workout) async throws
    func updateTemplatesPositions(_ templates: [Template]) async throws
    func loadExercises(from fileName: String) -> [String]
    
    func deleteTemplateExercise(_ templateExercise: TemplateExercise)
    func moveTemplate(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func moveTemplateExercise(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, template: Template)
}
