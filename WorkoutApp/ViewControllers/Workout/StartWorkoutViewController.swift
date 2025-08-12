//
//  StartWorkoutViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/1/25.
//

import UIKit

protocol StartWorkoutViewControllerDelegate: AnyObject {
    func startWorkoutViewController(_ viewController: StartWorkoutViewController, didFinishWorkout workout: Workout)
}

class StartWorkoutViewController: WorkoutDetailViewController {
    
    lazy var finishButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Finish".localized, primaryAction: didTapFinishButton())
    }()

    weak var progressDelegate: StartWorkoutViewControllerDelegate?  // progress handles

    init(template: Template, workoutService: WorkoutService) throws {
        let childContext = CoreDataStack.shared.childContext()
        let workout = try workoutService.createWorkout(template: template, context: childContext)
        super.init(workout: workout, workoutService: workoutService)
//        self.template = template
        for exercise in template.templateExercises {
            self.repsPlaceholder[exercise.name] = Array(repeating: exercise.reps, count: Int(exercise.sets))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [finishButton]
        
        if Settings.shared.showTimer {
            let timeElapsedButton = TimeElapsedBarButton()
            navigationItem.rightBarButtonItems?.append(timeElapsedButton)
        }
        
    }

    func didTapFinishButton() -> UIAction {
        return UIAction { _ in
            if self.workout.isFinished {
                self.showFinishAlert(title: "Workout Complete!", message: "Are you ready to finish your workout?")
            } else {
                self.showFinishAlert(title: "Finish Workout?", message: "Some weight or reps fields are still empty. Are you sure you want to finish your workout?")
            }
        }
    }
    
    func showFinishAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            self.didTapConfirmButton()
        })
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func didTapConfirmButton() {
        for exercise in workout.getExercises() {
            for set in exercise.getExerciseSets() {
                set.weight = max(set.weight, 0)
                set.reps = max(set.reps, 0)
                set.isComplete = true
            }
        }
        
        do {
            try childContext.save()
        } catch {
            print("Error saving reordered items: \(error)")
        }

        CoreDataStack.shared.saveContext()

        progressDelegate?.startWorkoutViewController(self, didFinishWorkout: workout)
        Settings.shared.logBadgeValue += 1
        NotificationCenter.default.post(name: Settings.logBadgeValueChangedNotification, object: nil)
        navigationController?.popViewController(animated: true)
    }
}
