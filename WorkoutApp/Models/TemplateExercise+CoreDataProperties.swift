//
//  TemplateExercise+CoreDataProperties.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 12/28/24.
//
//

import Foundation
import CoreData

extension TemplateExercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemplateExercise> {
        return NSFetchRequest<TemplateExercise>(entityName: "TemplateExercise")
    }
    
    static func fetchRequest(for template: Template) -> NSFetchRequest<TemplateExercise> {
        let request: NSFetchRequest<TemplateExercise> = TemplateExercise.fetchRequest()
        request.predicate = NSPredicate(format: "template == %@", template)
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        return request
    }

    @NSManaged public var name_: String?
    @NSManaged public var sets: Int16
    @NSManaged public var reps: Int16
    @NSManaged public var index: Int16
    @NSManaged public var template: Template?

    var name: String {
        get {
            return name_ ?? ""
        }
        set {
            name_ = newValue
        }
    }
}

extension TemplateExercise : Identifiable {

}
