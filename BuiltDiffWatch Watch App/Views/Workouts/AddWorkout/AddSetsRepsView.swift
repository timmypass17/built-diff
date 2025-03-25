//
//  AddSetsRepsView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/12/25.
//

import SwiftUI

struct AddSetsRepsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var exercise: TemplateExerciseWrapper
    var didAddExercise: (TemplateExerciseWrapper) -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack {
                    Text("Sets".uppercased())
                        .fontWeight(.semibold)
                    
                    Picker("Select set count", selection: $exercise.sets) {
                        ForEach((0..<100).reversed(), id: \.self) { number in
                            Text("\(number)")
                                .font(.title3)
                        }
                    }
                    .pickerStyle(.wheel)
                    .defaultWheelPickerItemHeight(30)
                    .labelsHidden()
                    .mask(RoundedRectangle(cornerRadius: 12).padding(2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                    .frame(height: 60)
                }
                
                VStack {
                    Text("reps".localized.localizedUppercase)
                        .fontWeight(.semibold)
                    
                    Picker("Select rep count", selection: $exercise.reps) {
                        ForEach((0..<100).reversed(), id: \.self) { number in
                            Text("\(number)")
                                .font(.title3)
                        }
                    }
                    .pickerStyle(.wheel)
                    .defaultWheelPickerItemHeight(30)
                    .labelsHidden()
                    .mask(RoundedRectangle(cornerRadius: 12).padding(2))    // hide green focused border
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.secondary, lineWidth: 1)
                    )
                    .frame(height: 60)
                }
            }
            .frame(height: 100)
            
            Button("Add Exercise", systemImage: "plus") {
                didAddExercise(exercise)
                dismiss()
            }
        }
        .navigationTitle(exercise.name)
    }
}

//#Preview {
//    AddSetsRepsView()
//}
