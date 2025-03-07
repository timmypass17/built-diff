//
//  WorkoutConfirmationCellView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/5/25.
//

import SwiftUI

struct WorkoutConfirmationCellView: View {
    @Environment(AppState.self) private var appState
    let index: Int
    let set: SetWrapper
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(index + 1)")
                .foregroundStyle(.secondary)
            
            Text("\(formatWeight(set.weight)) \(appState.weightUnit.rawValue)")
                .fontWeight(.semibold)
            
            Spacer()
            
            Text("x\(set.reps)")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    List {
        Section("Bench Press") {
            WorkoutConfirmationCellView(index: 0, set: SetWrapper(weight: 135, reps: 5, isComplete: false))
            WorkoutConfirmationCellView(index: 1, set: SetWrapper(weight: 135, reps: 5, isComplete: false))
        }
        
        Section("Squat") {
            WorkoutConfirmationCellView(index: 0, set: SetWrapper(weight: 225, reps: 5, isComplete: false))
            WorkoutConfirmationCellView(index: 1, set: SetWrapper(weight: 225, reps: 5, isComplete: false))
        }
    }
}
