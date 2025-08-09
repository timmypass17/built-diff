//
//  CoreDataStack.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 12/25/24.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {
        // Prevents direct initialization. To enforce a single instance of the class
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "BuiltDiff")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true // important for watchos and app sync
        return context
    }()
    
    func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
        
    // Child Context: A child context is a context that has a parent context
    // Use a child context for operations that you might want to discard or modify before committing them to the parent context (like editing a record temporarily)
    func newChildContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(.privateQueue) // only access it through the perform(_:) and the performAndWait(_:) methods
        childContext.parent = mainContext
        return childContext
        
        // Changes made in a child context are not saved directly to the persistent store. Instead, they're "pushed" up to the parent context using save(), and the parent context also needs to save for changes to be persisted in the store.
    }
    
    func childContext(parentContext: NSManagedObjectContext? = CoreDataStack.shared.mainContext) -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(.mainQueue)
        childContext.parent = parentContext
        return childContext
    }
    
    // Background Context: The background context is a private queue context, but it’s not a child of the main context.
    // Use a background context for heavier operations that need to be committed directly to the persistent store, such as importing data or performing batch operations.
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()   // private queue
        // no need for "double save" like child context
        // When you call backgroundContext.save(), the changes are immediately persisted to the persistent store.
        // You do not need to save the main context separately because the background context is not its child
    }
}


extension CoreDataStack {
    
    private convenience init(inMemory: Bool = false) {
        self.init()
        persistentContainer = NSPersistentCloudKitContainer(name: "BuiltDiff")
        
        // For in-memory stores (used in previews), point the store to /dev/null.
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    static let preview: CoreDataStack = {
        let inMemoryStack = CoreDataStack(inMemory: true)
        let context = inMemoryStack.mainContext
        
        // Create 3 sample Template objects.
        for i in 0..<3 {
            let template = Template(context: context)
            template.title = "Template \(i)"
            template.index = Int16(i)
            
            // For each Template, create 2 sample TemplateExercise objects.
            for j in 0..<2 {
                let exercise = TemplateExercise(context: context)
                exercise.name = "Exercise \(j) for Template \(i)"
                exercise.sets = Int16(3 + j)    // Example: 3, 4, etc.
                exercise.reps = Int16(10 + j * 2) // Example: 10, 12, etc.
                exercise.index = Int16(j)
                exercise.template = template    // Set the relationship.
                template.addToTemplateExercises_(exercise)
            }
        }
        
        // Create 2 sample Workout objects with related Exercises and ExerciseSets.
        for i in 0..<2 {
            let workout = Workout(context: context)
            workout.title = "Workout \(i)"
            workout.createdAt = Date().addingTimeInterval(-Double(i) * 3600) // staggered createdAt dates
            workout.index = Int16(i)
            
            // For each Workout, create 2 sample Exercise objects.
            for j in 0..<2 {
                let exercise = Exercise(context: context)
                exercise.name = "Exercise \(j) in Workout \(i)"
                exercise.index = Int16(j)
                exercise.workout = workout
                workout.addToExercises(exercise)
                
                // For each Exercise, create 3 sample ExerciseSet objects.
                for k in 0..<3 {
                    let set = ExerciseSet(context: context)
                    set.reps = Int16(8 + k)              // e.g., 8, 9, 10
                    set.weight = Double(50 + k * 5)        // e.g., 50, 55, 60 lbs
                    set.index = Int16(k)
                    // For demonstration, mark only the last set as complete.
                    set.isComplete = (k == 2)
                    set.exercise = exercise
                    exercise.addToExerciseSets(set)
                }
            }
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Error saving preview context: \(error)")
        }
        return inMemoryStack
    }()
}

// Core Data Notes:
// Note: main context for reads, background context for writes
// 1. In general, avoid doing data processing on the main queue that’s not user-related. Data processing can be CPU-intensive, and if it’s performed on the main queue, it can result in unresponsiveness in the user interface
//  - e.g. If your application processes data, such as importing data into Core Data from JSON, create a private queue context and perform the import on the private context
// 2. Don’t pass managed object instances between queues. Doing so can result in corruption of the data and termination of the app. When it’s necessary to hand off a managed object reference from one queue to another, use NSManagedObjectID instances.

// When to Use Each
// Child Context:
//      Use for temporary or isolated changes that you want to push to a parent context before persisting.
//          - e.g. editing a draft entity that updates the UI in real-time (via mainContext).
// Private Context:
//      Use for large, long-running tasks that need to directly persist changes to the store without involving the mainContext.
//          - e.g. importing/exporting data
