//
//  CreateTemplateTableViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/5/25.
//

import UIKit
import CoreData

class CreateTemplateViewController: TemplateViewController {

    lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .save, primaryAction: didTapCreateButton())
        return button
    }()
    
    init(workoutService: WorkoutService) throws {
        let childContext = CoreDataStack.shared.childContext()
        let newTemplate = try workoutService.createTemplate(childContext: childContext)
        super.init(template: newTemplate, workoutService: workoutService)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = String(localized: "Create Workout")
        navigationItem.rightBarButtonItems = [createButton]
        updateSaveButton()
    }
    
    func didTapCreateButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self else { return }
            
            do {
                try childContext.save()
                CoreDataStack.shared.saveContext()
                self.dismiss(animated: true)
            } catch {
                print("Error creating template: \(error)")
            }
        }
    }

    
}
