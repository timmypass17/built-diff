//
//  WorkoutsView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/2/25.
//

import SwiftUI
import Combine
import WatchConnectivity

struct WorkoutsView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Template.index, ascending: true)])
    private var templates: FetchedResults<Template>
    let command: Command = .updateAppContext
    @State var appState = AppState()

    var body: some View {
        List(templates) { template in
            NavigationLink(value: template) {
                WorkoutCellView(
                    iconName: "\(template.title.first?.lowercased() ?? "a").circle.fill",
                    title: template.title,
                    description: "\(template.templateExercises.count) exercises",
                    color: appState.color
                )
            }
        }
        .navigationDestination(for: Template.self) { template in
            WorkoutDetailView(workout: WorkoutWrapper(template: template))
                .environment(appState)
        }
        .onAppear() {
            updateWithInitialState()
        }
        .onReceive(NotificationCenter.default.dataDidFlowPublisher) { notification in
            dataDidFlow(notification)
        }
    }
}

#Preview {
    WorkoutsView()
}


extension NotificationCenter {
    var dataDidFlowPublisher: Publishers.ReceiveOn<NotificationCenter.Publisher, DispatchQueue> {
        return publisher(for: .dataDidFlow).receive(on: .main)
    }
}

/**
 Notification handler.
 Update the UI when getting a .dataDidFlow notification.
 */
extension WorkoutsView {
    private func dataDidFlow(_ notification: Notification) {
        print("[WorkoutsView] dataDidFlow()")
        guard let commandStatus = notification.object as? CommandStatus else { return }
        /**
         If the data is from the current channel, update the color and timestamp.
         */
        if commandStatus.command == command {
            updateUI(with: commandStatus, errorMessage: commandStatus.errorMessage)
            return
        }
    }
    
    /**
     Update the view with the initial session state.
     */
    private func updateWithInitialState() {
        print("[WorkoutsView] updateWithInitialState()")
        if command == .updateAppContext {
            let timedColor = WCSession.default.receivedApplicationContext
            if !timedColor.isEmpty {
                var commandStatus = CommandStatus(command: command, phrase: .received)
                commandStatus.timedColor = TimedColor(timedColor)
                updateUI(with: commandStatus)
            }
            return
        }
    }
    
    /**
     Update the user interface with the command status.
     There isn't a timed color when the app initially loads the interface.
     */
    private func updateUI(with commandStatus: CommandStatus, errorMessage: String? = nil) {
        print("[WorkoutsView] updateUI()")
        guard let timedColor = commandStatus.timedColor else { return }
        appState.color = Color(uiColor: timedColor.color)
    }
}


// FAQ: Detail view created each time for each list eagerly.
// Using NavigationDestination can fix this issue, as it ensures that the destination view is only initialized when the user actually navigates to it, rather than being eagerly created as part of the List rendering.
//            let workoutDao = WorkoutDao(context: context, backgroundContext: CoreDataStack.shared.newBackgroundContext())
//            let childContext = CoreDataStack.shared.newChildContext()
//            let workout = workoutDao.createWorkout(template: template, childContext: childContext)
//            WorkoutDetailView(workout: workout)
//                .environment(\.childContext, childContext)
