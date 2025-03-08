//
//  BuiltDiffWatchApp.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/2/25.
//

import SwiftUI

@main
struct BuiltDiffWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor var appDelegate: AppDelegate
    @State private var navigationPath = NavigationPath() // New navigation path

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                WorkoutsView(navigationPath: $navigationPath)
                    .navigationTitle("Workout")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environment(\.managedObjectContext, CoreDataStack.shared.mainContext)

        }
    }
}
