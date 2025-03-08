//
//  WorkoutsEmptyView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/7/25.
//

import SwiftUI

struct WorkoutsEmptyView: View {
    @State var isPresentingMoreInfoSheet = false
    
    var body: some View {
        VStack {
            Image(systemName: "dumbbell.fill")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            Text("No Workouts Yet")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Start adding workouts in the BuiltDiff app on your iPhone to see them here.")
                .font(.footnote)
                .foregroundColor(.secondary)
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
                    1. No workouts have been added in the BuiltDiff iPhone app.
                    2. Syncing with iCloud is still in progress (may take up to a minute for the first time).
                    3. Your iPhone and Apple Watch are using different iCloud accounts (they must match to sync data).
                    4. Background app refresh is disabled for the BuiltDiff app.
                    5. Poor network connectivity on either your iPhone or Apple Watch.
                    """)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                }
            }
            .navigationTitle("FAQ")
        }
    }
}

#Preview {
    WorkoutsEmptyView()
}
