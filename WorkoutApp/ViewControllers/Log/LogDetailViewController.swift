//
//  LogWorkoutViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/2/25.
//

import UIKit

protocol LogDetailViewControllerDelegate: AnyObject {
    func logDetailViewController(_ viewController: LogDetailViewController, didSaveLog log: Workout)
}

class LogDetailViewController: WorkoutDetailViewController {

    weak var delegate: LogDetailViewControllerDelegate?
    
    init(log: Workout, workoutService: WorkoutService) {
        let childContext = CoreDataStack.shared.childContext()
        let childWorkout = childContext.object(with: log.objectID) as! Workout
        super.init(workout: childWorkout, workoutService: workoutService)

        for exercise in log.getExercises() {
            for exerciseSet in exercise.getExerciseSets() {
                self.repsPlaceholder[exercise.name, default: []].append(exerciseSet.reps)
            }
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Save".localized, primaryAction: didTapSaveButton())
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar"), primaryAction: didTapCalendarButton())
        navigationItem.rightBarButtonItems = [saveButton, calendarButton]
    }
    
    override func didTapBackButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self else { return }
            if childContext.hasChanges {
                showExitAlert(
                    title: "Unsaved Changes",
                    message: "Changes you made to this workout session have not been saved. Do you want to leave without saving?",
                    primaryButtonText: "Discard Changes"
                )
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func didTapSaveButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self else { return }
            
            for exercise in workout.getExercises() {
                for set in exercise.getExerciseSets() {
                    if set.weight < 0 {
                        set.weight = 0
                    }
                    if set.reps < 0 {
                        set.reps = 0
                    }
                    set.isComplete = true
                }
            }
            
            do {
                try workout.managedObjectContext!.save()
            } catch {
                print("Error saving reordered items: \(error)")
            }
            
            CoreDataStack.shared.saveContext()
            
            self.delegate?.logDetailViewController(self, didSaveLog: workout)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func didTapCalendarButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self,
                  let createdAt = workout.createdAt_
            else { return }

            let calendarViewController = CalendarViewController(date: createdAt)
            calendarViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: calendarViewController)
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    return self.view.frame.height * 0.6
                })]
            }
            self.present(navigationController, animated: true)
        }
    }

}

extension LogDetailViewController: CalendarViewControllerDelegate {
    func calendarViewControllerDelegate(_ viewController: CalendarViewController, didSelectDate date: Date) {
        workout.createdAt_ = date
    }
}
