//
//  SegmentedProgressView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/3/25.
//

import SwiftUI

struct SegmentedProgressView: View {
    let sets: [SetWrapper]
    var selectedColor: Color = .blue
    var unselectedColor: Color = Color.secondary.opacity(0.3)
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<sets.count, id: \.self) { index in
                Rectangle()
                    .foregroundColor(sets[index].isComplete ? selectedColor : unselectedColor)
            }
        }
        .frame(maxHeight: 8)
        .clipShape(Capsule())
    }
}

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -200

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color.white.opacity(0.4),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: phase)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .delay(2)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 200
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(Shimmer())
    }
}

#Preview {
    SegmentedProgressView(sets: [
        SetWrapper(weight: 45, reps: 5, isComplete: true),
        SetWrapper(weight: 45, reps: 5, isComplete: false),
        SetWrapper(weight: 45, reps: 5, isComplete: false)
    ])
}
