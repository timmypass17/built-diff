//
//  SetView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/5/25.
//

import SwiftUI

struct SetView: View {
    @Bindable var set: SetWrapper
//    @Binding var selectedTab: Int
    var didTapNextButton: () -> Void
    var didTapPreviousButton: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack {
                    Text("Lbs".uppercased())
                        .fontWeight(.semibold)
                    
                    Picker("Select a weight", selection: $set.weight) {
                        ForEach(Array(stride(from: 1000.0, through: 0.0, by: -2.5)), id: \.self) { number in
                            Text(formatWeight(number))
                                .font(.title3)
                            //                                        .foregroundStyle(exerciseSet.isComplete ? Color.primary : Color.secondary)
                                .tag(number)
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
                    .disabled(set.isComplete)
                    .frame(height: 60)
                }
                
                VStack {
                    Text("Reps".uppercased())
                        .fontWeight(.semibold)
                    
                    Picker("Select reps", selection: $set.reps) {
                        ForEach((0..<100).reversed(), id: \.self) { number in
                            Text("\(number)")
                                .font(.title3)
                            //                                        .foregroundStyle(exerciseSet.isComplete ? Color.primary : Color.secondary)
                                .tag(number)
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
                    .disabled(set.isComplete)
                    .frame(height: 60)
                }
            }
            .frame(height: 100)
            
            HStack {
                Button {
                    didTapPreviousButton()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .labelStyle(.iconOnly)
                        .frame(width: 40, height: 25)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(UIColor.darkGray))
                        )
                }
                .buttonStyle(.plain)

                Toggle(isOn: $set.isComplete) {
                    Label("Set Status", systemImage: "checkmark")
                        .labelStyle(.iconOnly)
                        .frame(height: 25)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(set.isComplete ? Color.blue : Color(UIColor.darkGray))
                        )
                }
                .toggleStyle(.button)
                .buttonStyle(.plain)

                Button {
                    didTapNextButton()
                } label: {
                    Label("Forward", systemImage: "chevron.right")
                        .labelStyle(.iconOnly)
                        .frame(width: 40, height: 25)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(UIColor.darkGray))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    SetView(set: SetWrapper(weight: 135, reps: 5, isComplete: false), didTapNextButton: {}, didTapPreviousButton: {})
}
