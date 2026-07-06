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

    private let context: NSManagedObjectContext // reads    

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createTemplate(childContext: NSManagedObjectContext) throws -> Template {
        let newTemplate = Template(context: context)
        newTemplate.title = ""
        newTemplate.index = try getNextTemplateIndex()
        return newTemplate
    }

    private func getNextTemplateIndex() throws -> Int16 {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Template")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["index"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        fetchRequest.fetchLimit = 1

        let result = try context.fetch(fetchRequest)

        if let maxIndex = result.first?["index"] as? Int {
            return Int16(maxIndex + 1)
        } else {
            return 0
        }
    }

    func createWorkout(template: Template, context: NSManagedObjectContext) throws -> Workout {
        let workout = Workout(context: context)
        workout.title = template.title
        workout.createdAt_ = .now

        for templateExercise in template.templateExercises {
            let exercise = Exercise(context: context)
            exercise.name = templateExercise.name
            exercise.index = templateExercise.index
            exercise.workout = workout

            for i in 0..<templateExercise.sets {
                let exerciseSet = ExerciseSet(context: context)
                exerciseSet.isComplete = false
                exerciseSet.reps = -1   // negative means user has not inputted any value
                exerciseSet.weight = -1 // use previous weight (or template)
                exerciseSet.index = Int16(i)
                exerciseSet.exercise = exercise
                exercise.addToExerciseSets(exerciseSet)
            }

            workout.addToExercises(exercise)
        }

        return workout
    }
    
    func fetchLogs(from startDate: Date? = nil, to endDate: Date? = nil) throws -> [Workout] {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        if let startDate, let endDate {
            let predicate = NSPredicate(format: "createdAt_ >= %@ AND createdAt_ < %@", startDate as NSDate, endDate as NSDate)
            request.predicate = predicate
        }
        let sortDescriptor = NSSortDescriptor(key: "createdAt_", ascending: false)
        request.sortDescriptors = [sortDescriptor]

        let logs = try self.context.fetch(request)
        print("Fetched \(logs.count) logs")
        return logs
    }

    func fetchExerciseNames() throws -> [String] {
        // TODO: fetch from templateExercises instead? much smaller data set
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        request.propertiesToFetch = ["name_"] // Fetch only the 'name_' property
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true // Ensure only unique names are returned
        let results = try self.context.fetch(request) as? [[String: Any]]
        let uniqueNames = results?.compactMap { $0["name_"] as? String } ?? []
        print("Fetched \(uniqueNames.count) exercises")
        return uniqueNames.sorted()
    }

    func fetchExerciseSets(exerciseName: String, limit: Int? = nil, ascending: Bool, includeZeros: Bool = true) throws -> [ExerciseSet] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "name_ == %@", exerciseName)
        request.sortDescriptors = [NSSortDescriptor(key: "workout.createdAt_", ascending: ascending)]

        let exercises: [Exercise] = try self.context.fetch(request)

        var sets = exercises
            .compactMap { $0.bestSet }

        if !includeZeros {
            sets = sets
                .filter { $0.weight != 0 }
        }

        if let limit {
            sets = Array(sets.prefix(limit))
        }

        return sets
    }

    func fetchPR(exerciseName: String) throws -> Double {
        let request = NSFetchRequest<NSDictionary>(entityName: "ExerciseSet")
        request.predicate = NSPredicate(format: "exercise.name_ == %@", exerciseName)
        request.resultType = .dictionaryResultType

        // weights are stored as string, so transform string as double
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxWeight"
        expressionDescription.expression = NSExpression(forFunction: "max:", arguments: [NSExpression(forKeyPath: "weight")])
        expressionDescription.expressionResultType = .doubleAttributeType

        request.propertiesToFetch = [expressionDescription]

        guard let result = try self.context.fetch(request).first,
              let maxWeight = result["maxWeight"] as? Double
        else {
            return 0.0
        }

        return maxWeight
    }

    func deleteTemplate(_ template: Template) {
        CoreDataStack.shared.mainContext.delete(template)
        CoreDataStack.shared.saveContext()
        updateTemplateIndexes()
    }

    private func updateTemplateIndexes() {
        let fetchRequest: NSFetchRequest<Template> = Template.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]

        do {
            let templates = try CoreDataStack.shared.mainContext.fetch(fetchRequest)
            for (index, template) in templates.enumerated() {
                template.index = Int16(index)
            }

            CoreDataStack.shared.saveContext()
        } catch {
            print("Failed to fetch templates during delete: \(error)")
        }
    }

    func deleteTemplateExercise(_ templateExercise: TemplateExercise) {
        guard let childContext = templateExercise.managedObjectContext,
              let template = templateExercise.template
        else { return }

        childContext.delete(templateExercise)

        updateTemplateExercisesIndexes(for: template)
    }

    private func updateTemplateExercisesIndexes(for template: Template) {
        guard let childContext = template.managedObjectContext else { return }
        let fetchRequest: NSFetchRequest<TemplateExercise> = TemplateExercise.fetchRequest(for: template)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]

        do {
            let exercises = try childContext.fetch(fetchRequest)
            for (index, exercise) in exercises.enumerated() {
                exercise.index = Int16(index)
            }

            try childContext.save()
        } catch {
            print("Failed to fetch templates during delete: \(error)")
        }
    }

//    
//    func reorderTemplates(_ templates: [Template], moveWorkoutAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) async -> [Template] {
//        guard sourceIndexPath != destinationIndexPath else { return templates }
//        var updatedTemplates = templates
//        let workoutToMove = updatedTemplates.remove(at: sourceIndexPath.row)
//        updatedTemplates.insert(workoutToMove, at: destinationIndexPath.row)
//            
//        do {
//            try await workoutDao.updateTemplatesPositions(updatedTemplates)
//
//            return updatedTemplates
//        } catch {
//            print("Error reordering templates: \(error)")
//            return templates
//        }
//    }

    func loadExercises(from fileName: String) -> [String] {
        // Does load correct exercise.txt based on user's localization
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt"),
              let content = try? String(contentsOf: url) else { return [] }

        return content.components(separatedBy: "\n").filter { !$0.isEmpty }
    }

    func moveTemplate(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }

        let fetchRequest: NSFetchRequest<Template> = Template.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]

        do {
            var templates = try CoreDataStack.shared.mainContext.fetch(fetchRequest)

            let templateToMove = templates.remove(at: sourceIndexPath.row)
            templates.insert(templateToMove, at: destinationIndexPath.row)

            for (index, template) in templates.enumerated() {
                template.index = Int16(index)
            }

            CoreDataStack.shared.saveContext()
        } catch {
            print("Failed to reorder templates: \(error)")
        }
    }

    func moveTemplateExercise(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, template: Template) {
        guard sourceIndexPath != destinationIndexPath,
              let context = template.managedObjectContext
        else { return }

        let fetchRequest: NSFetchRequest<TemplateExercise> = TemplateExercise.fetchRequest(for: template)

        do {
            var templates = try context.fetch(fetchRequest)

            let templateToMove = templates.remove(at: sourceIndexPath.row)
            templates.insert(templateToMove, at: destinationIndexPath.row)

            for (index, template) in templates.enumerated() {
                template.index = Int16(index)
            }

            try context.save()  // we use nsfetch
        } catch {
            print("Failed to reorder templates: \(error)")
        }
    }

    func getLatestExerciseInfoDict(exercises: [String]) -> [String: [(Double, Int16)]] {  // exercises: [(lbs, reps)]
        var exerciseDict: [String: [(Double, Int16)]] = [:]
        for exerciseName in exercises {
            var inputs: [(Double, Int16)] = []
            let exercise = getLatestExercise(exerciseName: exerciseName)
            // Extract inputs
            let sets = exercise?.getExerciseSets() ?? []
            for item in sets {
                inputs.append((item.weight, item.reps))
            }
            exerciseDict[exerciseName] = inputs
        }
        return exerciseDict
    }
    
    func getLatestExercise(exerciseName: String) -> Exercise? {
        let context = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let predicate = NSPredicate(format: "name_ == %@", exerciseName)
        let sortDescriptor = NSSortDescriptor(key: "workout.createdAt_", ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        request.fetchLimit = 1
        
        do {
            let exercise: Exercise? = try context.fetch(request).first
            return exercise
        } catch {
            print("Error fetching previous exercise: \(error.localizedDescription)")
        }
        
        return nil
    }
    
}

// Core data testing:
// The solution is to create a Core Data stack subclass that uses an in-memory store rather than the current SQLite store. Because an in-memory store isn’t persisted to disk, when the test finishes executing, the in-memory store releases its data.
