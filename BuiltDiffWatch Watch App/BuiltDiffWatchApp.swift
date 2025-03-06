//
//  BuiltDiffWatchApp.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/2/25.
//

import SwiftUI

@main
struct BuiltDiffWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WorkoutsView()
                    .navigationTitle("Workout")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environment(\.managedObjectContext, CoreDataStack.shared.mainContext)

        }
    }
}
