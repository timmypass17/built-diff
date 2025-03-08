//
//  WorkoutCellView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI

struct WorkoutCellView: View {
    let iconName: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, color)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                Text(description)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    List {
        WorkoutCellView(iconName: "p.circle.fill", title: "Pull Day", description: "7 Exercises", color: .blue)
        WorkoutCellView(iconName: "p.circle.fill", title: "Push Day", description: "5 Exercises", color: .blue)
        WorkoutCellView(iconName: "l.circle.fill", title: "Leg Day", description: "4 Exercises", color: .blue)
    }
}
