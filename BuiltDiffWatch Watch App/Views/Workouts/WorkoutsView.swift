//
//  WorkoutsView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/2/25.
//

import SwiftUI
import Combine
import WatchConnectivity

// TODO: inital cloudkit sync takes up to 1 min
struct WorkoutsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Template.index, ascending: true)])
    private var templates: FetchedResults<Template>
    let command: Command = .updateAppContext
    @State var appState = AppState()
    @State var isPresentingMoreInfoSheet = false
    @Binding var navigationPath: NavigationPath
//    @State var isPresentingConfirmationSheet = false

    var body: some View {
        Group {
            if templates.isEmpty {
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
            } else {
                List(templates) { template in
//                    NavigationLink(value: template) {
                    // Use navigationPath instead of navigationLink for programtic control (e.g. pop to root)
                    Button {
                        navigationPath.append(template)
                    } label: {
                        WorkoutCellView(
                            iconName: "\(template.title.first?.lowercased() ?? "a").circle.fill",
                            title: template.title,
                            description: "\(template.templateExercises.count) exercises",
                            color: appState.color
                        )
                    }
//                    }
                }
            }
        }
        .navigationDestination(for: Template.self) { template in
            WorkoutDetailView(
                workout: WorkoutWrapper(template: template, weightUnit: appState.weightUnit),
                navigationPath: $navigationPath
            )
                .environment(appState)
        }
        .onAppear() {
            updateWithInitialState()
        }
        .onReceive(NotificationCenter.default.dataDidFlowPublisher) { notification in
            dataDidFlow(notification)
        }
//        .alert("Workout Saved!", isPresented: $appState.isPresentingSuccessAlert, actions: {
//            Button("Got it", role: .cancel) {
//                dismiss()
//            }
//        }, message: {
//            Text("Your workout has been successfully recorded.")
//        })
    }
}

//#Preview {
//    NavigationStack {
//        WorkoutsView()
//    }
//}


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
        if command == .updateAppContext {
            let userInfoDict: [String: Any] = WCSession.default.receivedApplicationContext   // most recent appContext
            
            if !userInfoDict.isEmpty {
                var commandStatus = CommandStatus(command: command, phrase: .received)
                commandStatus.userInfo = UserInfo(userInfoDict)
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
        guard let userInfo = commandStatus.userInfo else { return }
        appState.color = Color(uiColor: userInfo.color)
        appState.weightUnit = userInfo.weightType
    }
}


// FAQ: Detail view created each time for each list eagerly.
// Using NavigationDestination can fix this issue, as it ensures that the destination view is only initialized when the user actually navigates to it, rather than being eagerly created as part of the List rendering.
//            let workoutDao = WorkoutDao(context: context, backgroundContext: CoreDataStack.shared.newBackgroundContext())
//            let childContext = CoreDataStack.shared.newChildContext()
//            let workout = workoutDao.createWorkout(template: template, childContext: childContext)
//            WorkoutDetailView(workout: workout)
//                .environment(\.childContext, childContext)
