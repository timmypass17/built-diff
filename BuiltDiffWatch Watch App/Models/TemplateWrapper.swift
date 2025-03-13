//
//  TemplateWrapper.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import Foundation


@Observable
class TemplateWrapper {
    let id = UUID()
    var title: String = ""
    var index: Int16
    var templateExercises: [TemplateExerciseWrapper] = []
    
    init(index: Int16) {
        self.index = index
    }
}

extension TemplateWrapper: Hashable {
    static func == (lhs: TemplateWrapper, rhs: TemplateWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
