//
//  Template+CoreDataProperties.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 12/28/24.
//
//

import Foundation
import CoreData


extension Template {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Template> {
        let fetchRequest = NSFetchRequest<Template>(entityName: "Template")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    @NSManaged public var index: Int16
    @NSManaged public var title_: String?
    @NSManaged public var templateExercises_: NSSet?

    var title: String {
        get {
            return title_ ?? ""
        }
        set {
            title_ = newValue
        }
    }
    
    var templateExercises: [TemplateExercise] {
        return (templateExercises_?.allObjects as? [TemplateExercise] ?? []).sorted { $0.index < $1.index }
    }
    
    convenience init(templateWrapper: TemplateWrapper, context: NSManagedObjectContext) {
        self.init(context: context)
        title = templateWrapper.title
        index = templateWrapper.index
        
        for (i, exerciseWrapper) in templateWrapper.templateExercises.enumerated() {
            let templateExercise = TemplateExercise(context: context)
            templateExercise.name = exerciseWrapper.name
            templateExercise.sets = Int16(exerciseWrapper.sets)
            templateExercise.reps = Int16(exerciseWrapper.reps)
            templateExercise.index = Int16(i)
            templateExercise.template = self
            addToTemplateExercises_(templateExercise)
        }
    }
    
//    convenience init(workoutWrapper: WorkoutWrapper, weightUnit: WeightType, context: NSManagedObjectContext) {
//        self.init(context: context)
//        title = workoutWrapper.title
//        createdAt_ = workoutWrapper.createdAt
//        index = Int16(workoutWrapper.index)
//        
//        for (i, exerciseWrapper) in workoutWrapper.exercises.enumerated() {
//            let exercise = Exercise(context: context)
//            exercise.name = exerciseWrapper.name
//            exercise.index = Int16(i)
//            exercise.workout = self
//            
//            self.addToExercises(exercise)
//            for (j, setWrapper) in exerciseWrapper.sets.enumerated() {
//                let set = ExerciseSet(context: context)
//                if weightUnit == .lbs {
//                    set.weight = setWrapper.weight
//                } else if weightUnit == .kg {
//                    set.weight = setWrapper.weight.kgToLbs
//                }
//                set.reps = Int16(setWrapper.reps)
//                set.index = Int16(j)
//                set.isComplete = setWrapper.isComplete
//                set.exercise = exercise
//                exercise.addToExerciseSets(set)
//            }
//        }
//    }
}

// MARK: Generated accessors for templateExercises_
extension Template {

    @objc(addTemplateExercises_Object:)
    @NSManaged public func addToTemplateExercises_(_ value: TemplateExercise)

    @objc(removeTemplateExercises_Object:)
    @NSManaged public func removeFromTemplateExercises_(_ value: TemplateExercise)

    @objc(addTemplateExercises_:)
    @NSManaged public func addToTemplateExercises_(_ values: NSSet)

    @objc(removeTemplateExercises_:)
    @NSManaged public func removeFromTemplateExercises_(_ values: NSSet)

}

extension Template : Identifiable {

}
