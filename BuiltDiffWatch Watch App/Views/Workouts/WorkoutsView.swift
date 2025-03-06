//
//  WorkoutsView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/2/25.
//

import SwiftUI

struct WorkoutsView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Template.index, ascending: true)])
    private var templates: FetchedResults<Template>
    
    var body: some View {
        List(templates) { template in
            NavigationLink(value: template) {
                WorkoutCellView(
                    iconName: "\(template.title.first?.lowercased() ?? "a").circle.fill",
                    title: template.title,
                    description: "\(template.templateExercises.count) exercises"
                )
            }
        }
        .navigationDestination(for: Template.self) { template in
            WorkoutDetailView(workout: WorkoutWrapper(template: template))
        }
    }
}

#Preview {
    WorkoutsView()
}

// FAQ: Detail view created each time for each list eagerly.
// Using NavigationDestination can fix this issue, as it ensures that the destination view is only initialized when the user actually navigates to it, rather than being eagerly created as part of the List rendering.
//            let workoutDao = WorkoutDao(context: context, backgroundContext: CoreDataStack.shared.newBackgroundContext())
//            let childContext = CoreDataStack.shared.newChildContext()
//            let workout = workoutDao.createWorkout(template: template, childContext: childContext)
//            WorkoutDetailView(workout: workout)
//                .environment(\.childContext, childContext)
