//
//  WorkoutDetailOptionsView.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/14/25.
//

import SwiftUI

struct WorkoutDetailOptionsView: View {
    @Environment(AppState.self) private var appState
    @State var workoutDetailOptionsViewModel: WorkoutDetailOptionsViewModel
    var didDeleteTemplate: (Template) -> ()
    
    var body: some View {
        List {
            Section {
                Button("List View", systemImage: "list.bullet") {
                    workoutDetailOptionsViewModel.isPresentingListView.toggle()
                }
            }
            Section {
                Button("Delete Template", role: .destructive) {
                    workoutDetailOptionsViewModel.isPresentingDeleteAlert.toggle()
                }
            }
        }
        .alert("Delete Workout Template?", isPresented: $workoutDetailOptionsViewModel.isPresentingDeleteAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                didDeleteTemplate(workoutDetailOptionsViewModel.template)
                workoutDetailOptionsViewModel.isPresentingDeleteSuccessAlert.toggle()
            }
        }, message: {
            Text("This action is permanent and cannot be undone.")
        })
        .alert("Template Deleted", isPresented: $workoutDetailOptionsViewModel.isPresentingDeleteSuccessAlert, actions: {
            Button("OK".localized, role: .cancel) {
                appState.navigationPath.removeLast(appState.navigationPath.count)
            }
        }, message: {
            Text("Your workout template has been successfully deleted.")
        })
        .fullScreenCover(isPresented: $workoutDetailOptionsViewModel.isPresentingListView) {
            WorkoutReviewView(workoutReviewViewModel: WorkoutReviewViewModel(workout: workoutDetailOptionsViewModel.workout))
        }
    }
}

//#Preview {
//    WorkoutDetailOptionsView()
//}
