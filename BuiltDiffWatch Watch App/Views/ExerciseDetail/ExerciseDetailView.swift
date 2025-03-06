//
//  ExerciseView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI
import UIKit


//struct ExerciseDetailView: View {
//    let exercise: ExerciseWrapper
//    
//    var body: some View {
//        List {
//            ForEach(Array(exercise.sets.enumerated()), id: \.offset) { index, set in
//                HStack(spacing: 16) {
//                    Text("\(index + 1)")
//                        .foregroundStyle(.secondary)
//                    
//                    Text("\(formatWeight(set.weight)) lbs")
//                        .fontWeight(.semibold)
//                    
//                    Spacer()
//                    
//                    Text("x\(set.reps)")
//                        .foregroundStyle(.secondary)
//                }
//                .padding(.horizontal)
//            }
//        }
//        .swipeActions(edge: .leading, content: {
//            Text("Hello")
//        })
//        .navigationTitle(exercise.name)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}

struct ExerciseDetailView: View {
    @Bindable var exercise: ExerciseWrapper
    @State private var weight: Double = 45
    @State private var reps = 5
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
