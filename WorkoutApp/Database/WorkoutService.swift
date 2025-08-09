//
//  WorkoutService.swift
//  WorkoutApp
//
//  Created by Timmy Nguyen on 1/25/24.
//

import Foundation
import CoreData
import UIKit

class WorkoutService {
    
    private let workoutDao: WorkoutDaoProtocol
    
    init(workoutDao: WorkoutDaoProtocol) {
        self.workoutDao = workoutDao
    }
    
    func createTemplate(childContext: NSManagedObjectContext) -> Template {
        workoutDao.createTemplate(context: childContext)
    }
    
    func createWorkout(template: Template, childContext: NSManagedObjectContext) -> Workout {
        workoutDao.createWorkout(template: template, childContext: childContext)
    }
    
    func fetchTemplates() async -> [Template] {
        do {
            return try await workoutDao.fetchTemplates()
        } catch {
            return []
        }
    }
    
    func fetchLogs(from startDate: Date? = nil, to endDate: Date? = nil) async -> [Workout] {
        do {
            return try await workoutDao.fetchLogs(from: startDate, to: endDate)
        } catch {
            return []
        }
    }
    
    func fetchExerciseNames() async -> [String] {
        do {
            return try await workoutDao.fetchExerciseNames()
        } catch {
            return []
        }
    }
    
    func fetchExerciseSets(exerciseName: String, limit: Int? = nil, ascending: Bool = true) async -> [ExerciseSet] {
        do {
            return try await workoutDao.fetchExerciseSets(exerciseName: exerciseName, limit: limit, ascending: ascending)
        } catch {
            return []
        }
    }
    
    func fetchPR(exerciseName: String) async -> Double {
        do {
            return try await workoutDao.fetchPR(exerciseName: exerciseName)
        } catch {
            return 0.0
        }
    }
    
    func deleteTemplate(_ template: Template) {
        workoutDao.deleteTemplate(template)
    }
    
    func deleteLog(_ logs: [Date: [Workout]], at indexPath: IndexPath) async -> [Date: [Workout]] {
        do {
            var updatedLogs = logs
            let monthYears = logs.keys.sorted(by: >)
            let monthYear = monthYears[indexPath.section]
            let logToRemove = updatedLogs[monthYear, default: []].remove(at: indexPath.row)
            try await workoutDao.deleteLog(logToRemove)
            return updatedLogs
        } catch {
            print("error deleting template: \(error)")
            return logs
        }
    }
    
    func reorderTemplates(_ templates: [Template], moveWorkoutAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) async -> [Template] {
        guard sourceIndexPath != destinationIndexPath else { return templates }
        var updatedTemplates = templates
        let workoutToMove = updatedTemplates.remove(at: sourceIndexPath.row)
        updatedTemplates.insert(workoutToMove, at: destinationIndexPath.row)
            
        do {
            try await workoutDao.updateTemplatesPositions(updatedTemplates)

            return updatedTemplates
        } catch {
            print("Error reordering templates: \(error)")
            return templates
        }
    }
    
    func loadExercises(from fileName: String) -> [String] {
        return workoutDao.loadExercises(from: fileName)
    }
    
}

// Core data testing:
// The solution is to create a Core Data stack subclass that uses an in-memory store rather than the current SQLite store. Because an in-memory store isn’t persisted to disk, when the test finishes executing, the in-memory store releases its data.

// Q: Why DAO?
// A: DAO (Data Access Object is responsible for data access logic (e.g.g CRUD operations in your database (Core Data)).
//    Service class doesn't need to know "how" data is stored/fetched, just knows what operations it can perform
//    - this seperation allows us to swap DAO implementations (e.g. switch Core Data to Firebase) without changing service layer
//    - allows us to test dao independently
// DAO: Responsible solely for data access logic — how to read, write, update, delete data from your database (in this case, Core Data).
// Service: Responsible for business logic — rules, workflows, combining multiple DAO calls, coordinating actions, preparing data for UI or other layers.
// So your WorkoutService calls the DAO for raw data operations, and potentially adds business logic on top. This makes your code more modular, maintainable, and testable.
