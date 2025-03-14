//
//  TemplateExerciseWrapper.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import Foundation

@Observable
class TemplateExerciseWrapper {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var index: Int
    
    init(name: String, sets: Int, reps: Int, index: Int) {
        self.name = name
        self.sets = sets
        self.reps = reps
        self.index = index
    }
}

extension TemplateExerciseWrapper: Hashable {
    static func == (lhs: TemplateExerciseWrapper, rhs: TemplateExerciseWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TemplateExerciseWrapper: Identifiable {
    
}

extension TemplateExerciseWrapper: CustomStringConvertible {
    var description: String {
        return """
        TemplateExerciseWrapper(
            id: \(id),
            name: "\(name)",
            sets: \(sets),
            reps: \(reps),
            index: \(index)
        )
        """
    }
}
