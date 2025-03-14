//
//  SetWrapper.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/4/25.
//

import Foundation

@Observable
class SetWrapper {
    let id = UUID()
    var weight: Double
    var reps: Int
    var isComplete: Bool
    
    init(weight: Double, reps: Int, isComplete: Bool) {
        self.weight = weight
        self.reps = reps
        self.isComplete = isComplete
    }
}

extension SetWrapper: Identifiable {}

extension SetWrapper {
    static let samples: [SetWrapper] = [
        SetWrapper(weight: 45, reps: 12, isComplete: true),
        SetWrapper(weight: 135, reps: 5, isComplete: false),
        SetWrapper(weight: 225, reps: 5, isComplete: false)
    ]
}
