//
//  EditTemplateViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/6/25.
//

import UIKit
import CoreData

protocol EditTemplateViewControllerDelegate: AnyObject {
    func editTemplateViewController(_ viewController: EditTemplateViewController, didUpdateTemplate template: Template)
}

enum CoreDataError: Error {
    case objectNotFound
    case wrongType
}

class EditTemplateViewController: TemplateViewController {

    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .save, primaryAction: didTapSaveButton())
        return button
    }()
    
    weak var delegate: EditTemplateViewControllerDelegate?

    init(templateID: NSManagedObjectID, workoutService: WorkoutService) throws {
        let childContext = CoreDataStack.shared.childContext()
        guard let childTemplate = try childContext.existingObject(with: templateID) as? Template else {
            throw CoreDataError.wrongType
        }
        print(childTemplate)
        super.init(template: childTemplate, workoutService: workoutService)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Workout".localized
        navigationItem.rightBarButtonItems = [saveButton]
        updateSaveButton()
    }
    
    func didTapSaveButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.editTemplateViewController(self, didUpdateTemplate: template)
            self.dismiss(animated: true)
        }
    }

}
