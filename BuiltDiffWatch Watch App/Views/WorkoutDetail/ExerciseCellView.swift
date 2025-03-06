//
//  WorkoutDetailCellView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI

struct ExerciseCellView: View {
    let exercise: ExerciseWrapper
    
    var didFinishExercise: Bool {
        exercise.sets.allSatisfy { $0.isComplete }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .fontWeight(.semibold)
            
            Text("\(exercise.sets.count { $0.isComplete })/\(exercise.sets.count) sets")
                .foregroundStyle(.secondary)
                .font(.caption)
            
            if didFinishExercise {
                SegmentedProgressView(sets: exercise.sets)
                    .shimmer()
            } else  {
                SegmentedProgressView(sets: exercise.sets)
            }
        }
        .padding(.vertical)
    }
}

//#Preview {
//    List {
//        ExerciseCellView(title: "Bench Press", description: "0/2 sets", setCount: 5)
//    }
//}
