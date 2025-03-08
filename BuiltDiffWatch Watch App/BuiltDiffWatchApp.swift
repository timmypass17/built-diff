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
    @State var appState = AppState()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.navigationPath) {
                WorkoutsView(workoutsViewModel: WorkoutsViewModel())
                    .onAppear() {
                        appState.updateWithInitialState()
                    }
                    .onReceive(NotificationCenter.default.dataDidFlowPublisher) { notification in
                        appState.dataDidFlow(notification)
                    }
                    .environment(\.managedObjectContext, CoreDataStack.shared.mainContext)
                    .environment(appState)
            }
        }
    }
}
