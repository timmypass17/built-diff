//
//  CreateTemplateTableViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 1/5/25.
//

import UIKit
import CoreData

class CreateTemplateViewController: TemplateViewController {

    init(workoutService: WorkoutService) {
        let childContext = CoreDataStack.shared.childContext()
        let newTemplate = workoutService.createTemplate(childContext: childContext)
        super.init(template: newTemplate, workoutService: workoutService)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Workout".localized
        navigationItem.rightBarButtonItems?.insert(UIBarButtonItem(systemItem: .save, primaryAction: didTapCreateButton()), at: 0)
        updateSaveButton()
    }
    
    func didTapCreateButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self else { return }
            
            do {
                let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Template")
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.propertiesToFetch = ["index"]
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
                fetchRequest.fetchLimit = 1
                
                if let result = try? childContext.fetch(fetchRequest),
                   let maxIndex = result.first?["index"] as? Int {
                    template.index = Int16(maxIndex + 1)
                } else {
                    template.index = 0
                }
                
                try childContext.save()
                
                CoreDataStack.shared.saveContext()
                self.dismiss(animated: true)
            } catch {
                print("Error creating template: \(error)")
            }
        }
    }

}
