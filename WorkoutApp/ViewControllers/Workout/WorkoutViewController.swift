//
//  WorkoutViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 12/25/24.
//

import UIKit
import CoreData

class WorkoutViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var contentUnavailableView: UIView = {
        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.text = "No Workouts Yet"
        configuration.secondaryText = "Your workouts will appear here once you add them."
        configuration.image = UIImage(systemName: "dumbbell")

        let view = UIContentUnavailableView(configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var addButton: UIBarButtonItem!
    
//    private let context = CoreDataStack.shared.mainContext
    private let workoutService: WorkoutService
        
    // https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller
    var fetchedResultsController: NSFetchedResultsController<Template>! // source of truth
    var changeIsUserDriven = false

    init(workoutService: WorkoutService) {
        self.workoutService = workoutService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Workout".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.reuseIdentifier)
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: didTapAddButton())
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        view.addSubview(contentUnavailableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentUnavailableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentUnavailableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentUnavailableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NotificationCenter.default.addObserver(tableView,
                                               selector: #selector(UITableView.reloadData),
                                               name: AccentColor.valueChangedNotification, object: nil)
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: Template.fetchRequest(),
            managedObjectContext: CoreDataStack.shared.mainContext,
            sectionNameKeyPath: nil,    // to define sections
            cacheName: nil)

        fetchedResultsController.delegate = self
        
        // Perform a fetch.
        do {
            // actually fetches from cloudkit, when delete and reinstall app
            try fetchedResultsController?.performFetch()
            contentUnavailableView.isHidden = !(fetchedResultsController.fetchedObjects?.isEmpty ?? true)
        } catch {
            // Handle error appropriately. It's useful to use
            // `fatalError(_:file:line:)` during development.
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    private func didTapAddButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self else { return }
            let createWorkoutViewController = CreateTemplateViewController(workoutService: workoutService)
//            createWorkoutViewController.delegate = self
            let vc = UINavigationController(rootViewController: createWorkoutViewController)
            self.present(vc, animated: true)
        }
    }
    
    private func showDeleteAlert(_ template: Template) {
        let alert = UIAlertController(
            title: "Delete Template?".localized,
            message: "Are you sure you want to delete \"\(template.title)\"".localized,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove".localized, style: .destructive) { [weak self] _ in
            guard let self else { return }
            workoutService.deleteTemplate(template)
            // don't delete and update at same time, confuses delegate (so i split saveContext() it 2 parts)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapEditWorkoutButton(_ template: Template) -> UIAction {
        return UIAction(title: "Edit Workout".localized, image: UIImage(systemName: "square.and.pencil")) { _ in
            do {
                let childContext = CoreDataStack.shared.childContext()
                let templateInChild = try childContext.existingObject(with: template.objectID) as! Template
                let editTemplateViewController = EditTemplateViewController(template: templateInChild, workoutService: self.workoutService)
                editTemplateViewController.delegate = self
                let vc = UINavigationController(rootViewController: editTemplateViewController)
                self.present(vc, animated: true)
            } catch {
                print("Error moving template to child context: \(error)")
            }
        }
    }
    
    func didTapDeleteWorkoutButton(_ template: Template) -> UIAction {
        return UIAction(title: "Delete Workout".localized, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            guard let self else { return }
            showDeleteAlert(template)
        }
    }
}

extension WorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController?.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.reuseIdentifier, for: indexPath) as! WorkoutTableViewCell
        let template = fetchedResultsController.object(at: indexPath)
        cell.update(template: template)
        return cell
    }

}

extension WorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let template = fetchedResultsController.object(at: indexPath)
        let startWorkoutViewController = StartWorkoutViewController(template: template, workoutService: workoutService)

        let progressTableViewController = (tabBarController?.viewControllers?[2] as? UINavigationController)?.viewControllers[0] as! ProgressViewController
        startWorkoutViewController.progressDelegate = progressTableViewController

        navigationController?.pushViewController(startWorkoutViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // Changed relationship delete rule to "Cascade" (delete Workout A, deletes exercises and sets too)
            let template = fetchedResultsController.object(at: indexPath)
            showDeleteAlert(template)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            guard let self else { return nil }
            let template = self.fetchedResultsController.object(at: indexPath)

            return UIMenu(
                title: "",
                children: [didTapEditWorkoutButton(template), didTapDeleteWorkoutButton(template)])
        }
    }
    
}

extension WorkoutViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        let template = fetchedResultsController.object(at: indexPath)
        dragItem.localObject = template
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return  }
        
        // https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate#1661452
        // why ignore update by nsfetchedresultcontroller? the table view is already in the appropriate state because of the user’s action.
        changeIsUserDriven = true
        defer { changeIsUserDriven = false }
        
        workoutService.moveTemplate(from: sourceIndexPath, to: destinationIndexPath)
    }
    
}

extension WorkoutViewController: EditTemplateViewControllerDelegate {
    func editTemplateViewController(_ viewController: EditTemplateViewController, didUpdateTemplate template: Template) {
        
        for (index, templateExercise) in template.templateExercises.enumerated() {
            templateExercise.index = Int16(index)
            print("\(templateExercise.name) \(templateExercise.index)")
        }
        
        do {
            try viewController.childContext.save()
        } catch {
            print("Error updating template: \(error)")
        }
        
        CoreDataStack.shared.saveContext()
    }
}

// do stuff when changes in context happen
extension WorkoutViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
        contentUnavailableView.isHidden = !(controller.fetchedObjects?.isEmpty ?? true)
    }
    
    // Find out when the fetched results controller adds, removes, moves, or updates a fetched object.
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard changeIsUserDriven == false else { return }

        switch type {
        case .insert:
            guard let newIndexPath else { return }
            // Insert a new row with fade animation when the fetched results
            // controller adds or moves an object to the specified index path.
            print("Insert row: \(newIndexPath)")
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath else { return }
            // Delete the row with animation at the old index path when the fetched
            // results controller deletes or moves the associated object.
            print("Delete row: \(indexPath)")
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath else { return }
            // Update the cell as the specified indexPath.
            print("Update row: \(indexPath)")
            if let cell = tableView.cellForRow(at: indexPath) as? WorkoutTableViewCell {
                let template = fetchedResultsController.object(at: indexPath)
                cell.update(template: template)
            }
        case .move:
            guard let indexPath, let newIndexPath else { return }
            print("Move row: \(indexPath) to \(newIndexPath)")
            // Move a row from the specified index path to the new index path.
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            break
        }
    }
}
