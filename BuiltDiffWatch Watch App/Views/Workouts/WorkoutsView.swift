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
    @Environment(AppState.self) private var appState
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Template.index, ascending: true)])
    private var templates: FetchedResults<Template>
    @State var workoutsViewModel: WorkoutsViewModel
    
    var body: some View {
        Group {
            if templates.count < 5 {
                WorkoutsEmptyView {
                    appState.navigationPath.append(TemplateWrapper(index: Int16(templates.count)))
                }
            } else {
                List {
                    ForEach(templates) { template in
                        Button {
                            appState.navigationPath.append(template)
                        } label: {
                            WorkoutCellView(
                                iconName: "\(template.title.first?.lowercased() ?? "a").circle.fill",
                                title: template.title,
                                description: "\(template.templateExercises.count) exercises",
                                color: appState.color
                            )
                        }
                    }
                    
                    Button("Add Workout") {
                        appState.navigationPath.append(TemplateWrapper(index: Int16(templates.count)))
                    }
                }
                .navigationTitle("Workout")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationDestination(for: Template.self) { template in
            WorkoutDetailView(workoutDetailViewModel: WorkoutDetailViewModel(workout: WorkoutWrapper(template: template, weightUnit: appState.weightUnit)))
                .environment(appState)
        }
        .navigationDestination(for: TemplateWrapper.self) { templateWrapper in
            AddWorkoutView(addWorkoutViewModel: AddWorkoutViewModel(template: templateWrapper))
                .environment(appState)
        }
    }
}


#Preview {
    NavigationStack {
        WorkoutsView(workoutsViewModel: WorkoutsViewModel())
            .environment(AppState())
            .environment(\.managedObjectContext, CoreDataStack.preview.mainContext)
    }
}

// FAQ: Detail view created each time for each list eagerly.
// Using NavigationDestination can fix this issue, as it ensures that the destination view is only initialized when the user actually navigates to it, rather than being eagerly created as part of the List rendering.
//            let workoutDao = WorkoutDao(context: context, backgroundContext: CoreDataStack.shared.newBackgroundContext())
//            let childContext = CoreDataStack.shared.newChildContext()
//            let workout = workoutDao.createWorkout(template: template, childContext: childContext)
//            WorkoutDetailView(workout: workout)
//                .environment(\.childContext, childContext)
