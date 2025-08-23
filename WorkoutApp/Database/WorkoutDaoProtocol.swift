//
//  WorkoutDaoProtocol.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/14/25.
//

import Foundation
import CoreData

protocol WorkoutDaoProtocol {
    func createTemplate(context: NSManagedObjectContext) throws -> Template
    func createWorkout(template: Template, context: NSManagedObjectContext) throws -> Workout
    func fetchLogs(from startDate: Date?, to endDate: Date?) throws -> [Workout]
    func fetchExerciseNames() throws -> [String]
    func fetchExerciseSets(exerciseName: String, limit: Int?, ascending: Bool, includeZeros: Bool) throws -> [ExerciseSet]
    func fetchPR(exerciseName: String) throws -> Double
    func deleteTemplate(_ template: Template)
    func deleteTemplateExercise(_ templateExercise: TemplateExercise)
    func loadExercises(from fileName: String) -> [String]
    func moveTemplate(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func moveTemplateExercise(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, template: Template)
}
