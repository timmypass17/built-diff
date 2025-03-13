//
//  WorkoutsEmptyView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/7/25.
//

import SwiftUI

struct WorkoutsEmptyView: View {
    @State var isPresentingMoreInfoSheet = false
    var didTapAddWorkout: () -> ()
    
    var body: some View {
        ScrollView {
            Image(systemName: "dumbbell.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            Text("No Workouts Yet")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Create your first template and start your workouts here.")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button("Add Workout") {
                didTapAddWorkout()
            }
            .controlSize(.regular)
        }
        .multilineTextAlignment(.center)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentingMoreInfoSheet.toggle()
                } label: {
                    Label("More Info", systemImage: "questionmark")
                }
            }
        }
        .fullScreenCover(isPresented: $isPresentingMoreInfoSheet) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Q: Why am I not seeing any workouts?")
                    Text("""
                    There are a few possible reasons:
                    1. Syncing with iCloud is still in progress (may take up to a minute for the first time).
                    2. Your iPhone and Apple Watch are using different iCloud accounts (they must match to sync data).
                    3. Background app refresh is disabled for the BuiltDiff app (Go to Settings -> Apps -> BuiltDiff  -> Enable Background App Refresh.
                    4. Poor network connectivity on either your iPhone or Apple Watch.
                    """)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                }
            }
            .navigationTitle("FAQ")
        }
    }
}

//#Preview {
//    WorkoutsEmptyView()
//}
