//
//  ExerciseWrapper.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/4/25.
//

import Foundation

@Observable
class ExerciseWrapper {
    let id = UUID()
    var name: String
    var sets: [SetWrapper]
    
    init(name: String, sets: [SetWrapper]) {
        self.name = name
        self.sets = sets
    }
}

extension ExerciseWrapper: Identifiable {}

extension ExerciseWrapper: Hashable {
    static func == (lhs: ExerciseWrapper, rhs: ExerciseWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
