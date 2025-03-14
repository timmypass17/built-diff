//
//  ExerciseView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI
import UIKit

struct ExerciseDetailView: View {
    @Bindable var exercise: ExerciseWrapper
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, exerciseSet in
                SetView(set: exerciseSet) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = min(selectedTab + 1, exercise.sets.count - 1)
                    }
                } didTapPreviousButton: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = max(selectedTab - 1, 0)
                    }
                }
                .tag(index)
            }
        }
        .navigationTitle(exercise.name)
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: ExerciseWrapper(
                name: "Bench Press",
                sets: [
                    SetWrapper(weight: -1, reps: -1, isComplete: false),
                    SetWrapper(weight: -1, reps: -1, isComplete: false)
                ]
            )
        )
    }
}
