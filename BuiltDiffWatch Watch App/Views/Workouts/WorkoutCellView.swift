//
//  WorkoutCellView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI

struct WorkoutCellView: View {
    var iconName: String
    let title: String
    let exerciseCount: Int
    let color: Color
    
    
    init(iconName: String, title: String, exerciseCount: Int, color: Color) {
        let userLanguage = Locale.preferredLanguages.first ?? "en"
        if userLanguage.starts(with: "en") {
            self.iconName = iconName
        } else {
            self.iconName = "figure.strengthtraining.traditional.circle.fill"
        }
        self.title = title
        self.exerciseCount = exerciseCount
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, color)
            
            VStack(alignment: .leading) {
                // TODO: Local
//                Text(translation[title] ?? title)
//                    .fontWeight(.semibold)
//                    .lineLimit(1)
                Text(title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text("%\(exerciseCount) Exercises")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
    }
}

//#Preview {
//    List {
//        WorkoutCellView(iconName: "p.circle.fill", title: "Pull Day", description: "7 Exercises", color: .blue)
//        WorkoutCellView(iconName: "p.circle.fill", title: "Push Day", description: "5 Exercises", color: .blue)
//        WorkoutCellView(iconName: "l.circle.fill", title: "Leg Day", description: "4 Exercises", color: .blue)
//    }
//}
