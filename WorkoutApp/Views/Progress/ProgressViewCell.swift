//
//  ProgressViewCell.swift
//  WorkoutApp
//
//  Created by Timmy Nguyen on 2/7/24.
//

import SwiftUI
import Charts

struct ProgressViewCell: View {
    static let reuseIdentifier = "ProgressCell"
    @ObservedObject var recentData: ExerciseData
    @AppStorage("weightUnit") var weightUnit: WeightType = Settings.shared.weightUnit
    
    var chartData: [(offset: Int, element: Double)] {
        return Array(recentData.exerciseSets.map {
            weightUnit == .lbs ? $0.weight : $0.weight.lbsToKg
        }.enumerated())
    }
    
    var lastUpdatedText: String {
        let date = recentData.exerciseSets.last?.exercise?.workout?.createdAt ?? .now
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        return (recentData.exerciseSets.last?.exercise?.workout?.createdAt ?? .now).formatted(date: .abbreviated, time: .omitted)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "dumbbell.fill")
                            .foregroundColor(.accentColor)
                        // TODO: local
                        Text(recentData.name)
                            .minimumScaleFactor(0.85)
                            .lineLimit(1)
                        //                    Text(translation[recentData.name] ?? "")
                    }
                    .font(.system(.headline, weight: .bold))
                    
                    VStack(alignment: .leading) {
                        
                        Text("Best: \(Settings.shared.weightUnit == .lbs ? recentData.bestLift.lbsString : recentData.bestLift.kgString) \(Settings.shared.weightUnit.shortDescription)")
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("Latest: \(Settings.shared.weightUnit == .lbs ? recentData.latestLift.lbsString : recentData.latestLift.kgString) \(Settings.shared.weightUnit.shortDescription)")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        
                        Text("Updated: \(lastUpdatedText)")
                            .foregroundColor(.secondary)
                            .font(.caption2)
                        
                    }
                }
                
                Spacer(minLength: 20)
                
                // TODO: Bug if switching between lbs/kg (and tapping into detail)
                Chart(chartData, id: \.0) { index, weight in
                    LineMark(
                        x: .value("Position", index),
                        y: .value("Weight", weight)
                    )
                    .symbol(Circle().strokeBorder(lineWidth: 2))
                    .symbolSize(CGSize(width: 6, height: 6))
                }
                .chartXAxis(.hidden)
                .chartYScale(domain: .automatic(includesZero: false))
                .padding(.vertical, 8)
                .frame(width: geometry.size.width * 0.5)
            }
        }
        .frame(height: 90)
    }
}

struct ExerciseTitleView: View {
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "dumbbell.fill")
                .foregroundColor(.accentColor)
            Text(title)
        }
        .font(.system(.headline, weight: .bold))
    }
}

struct HighestWeightView: View {
    @AppStorage("weightUnit") var weightUnit: WeightType = Settings.shared.weightUnit
    var sets: [ExerciseSet]
    
    var highestWeight: String {
        return sets.max { set, otherSet in
            let weight = Float(set.weight)
            let otherWeight = Float(otherSet.weight)
            return weight < otherWeight
        }!.weightString
    }
    
    var latestSet: ExerciseSet {
        // Get latest sets from same date
        let latestDate = sets.last?.exercise?.workout?.createdAt_
        var latestSets: [ExerciseSet] = []
        var i = sets.count - 1;
        while i >= 0 && sets[i].exercise?.workout?.createdAt_ == latestDate {
            latestSets.append(sets[i])
            i -= 1
        }
        return latestSets.max { set, otherSet in
            let weight = Float(set.weight)
            let otherWeight = Float(otherSet.weight)
            return weight < otherWeight
        }!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best: \(highestWeight) \(weightUnit.shortDescription)")
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            HStack(alignment: .firstTextBaseline) {
                Text("Latest: \(latestSet.weightString) \(weightUnit.shortDescription)")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Text("Updated: \(latestSet.exercise?.workout?.createdAt_?.formatted(date: .abbreviated, time: .omitted) ?? Date().formatted(date: .abbreviated, time: .omitted))")
                .foregroundColor(.secondary)
                .font(.caption2)

        }
    }
}

// TODO: Not used. remove?
struct ExerciseChartView: View {
    var weights: [Double]
    
    var body: some View {
        Chart(Array(weights.enumerated()), id: \.0) { index, weight in
            LineMark(
                x: .value("Position", index),
                y: .value("Weight", weight)
            )
            .symbol(Circle().strokeBorder(lineWidth: 2))
            .symbolSize(CGSize(width: 6, height: 6))
        }
        .chartXAxis(.hidden)
//        .chartYAxis(.hidden)
        .chartYScale(domain: .automatic(includesZero: false))
        .padding(.vertical, 8)
    }
}
    
