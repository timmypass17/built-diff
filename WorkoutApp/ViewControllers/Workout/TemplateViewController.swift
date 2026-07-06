//
//  CreateWorkoutViewController.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 12/27/24.
//

import UIKit
import CoreData

class TemplateViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var template: Template
    let childContext: NSManagedObjectContext
    let workoutService: WorkoutService

    var fetchedResultsController: NSFetchedResultsController<TemplateExercise>! // source of truth
    var changeIsUserDriven = false

    enum Section: Int, CaseIterable {
        case title, exercises
    }

    init(template: Template, workoutService: WorkoutService) {
        self.template = template
        self.childContext = template.managedObjectContext!
        self.workoutService = workoutService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        navigationController?.presentationController?.delegate = self
        tableView.register(TemplateTitleTableViewCell.self, forCellReuseIdentifier: TemplateTitleTableViewCell.reuseIdentifier)
        tableView.register(TemplateExerciseTableViewCell.self, forCellReuseIdentifier: TemplateExerciseTableViewCell.reuseIdentifier)
        tableView.register(AddTemplateExerciseTableViewCell.self, forCellReuseIdentifier: AddTemplateExerciseTableViewCell.reuseIdentifier)

        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: didTapCancelButton())

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: TemplateExercise.fetchRequest(for: template),
            managedObjectContext: childContext,
            sectionNameKeyPath: nil,    // to define sections
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            // Handle error appropriately. It's useful to use
            // `fatalError(_:file:line:)` during development.
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }

    func updateSaveButton() {
        navigationItem.rightBarButtonItems?[0].isEnabled = !template.title.isEmpty && template.templateExercises.count > 0
    }

    func didTapCancelButton() -> UIAction {
        return UIAction { _ in
            // saving child context pushes changes to main context so in memory data actually changes but not saved to disk, only saved in memory
            // when main context is save, then changes are fully saved to disk
            // - use rollback to undo commits
            // This will undo all unsaved changes in the main context and revert it to the last committed state (i.e., before the child context’s changes were saved into it).
            CoreDataStack.shared.mainContext.rollback()
            self.dismiss(animated: true)
        }
    }
}

extension TemplateViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .title:
            return 1
        case .exercises:
            let addExerciseButton = 1
            let count = fetchedResultsController?.fetchedObjects?.count ?? 0
            return count + addExerciseButton
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: TemplateTitleTableViewCell.reuseIdentifier, for: indexPath) as! TemplateTitleTableViewCell
            cell.delegate = self
            cell.update(title: template.title)
            return cell
        case .exercises:
            let count = fetchedResultsController?.fetchedObjects?.count ?? 0
            let isAddButtonRow = indexPath.row == count
            if isAddButtonRow {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddTemplateExerciseTableViewCell.reuseIdentifier, for: indexPath) as! AddTemplateExerciseTableViewCell
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: TemplateExerciseTableViewCell.reuseIdentifier, for: indexPath) as! TemplateExerciseTableViewCell
            let offsetIndexPath = IndexPath(row: indexPath.row, section: 0)
            let templateExercise = fetchedResultsController.object(at: offsetIndexPath) // this FRC internally only has 1 section
            cell.update(templateExercise: templateExercise)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .title:
            return String(localized: "Title")
        case .exercises:
            return String(localized: "Exercises")
        }
    }


}

extension TemplateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isAddButtonRow = indexPath.row == template.templateExercises.count
        guard let section = Section(rawValue: indexPath.section),
              section == .exercises
        else { return }
        
        if isAddButtonRow {
            tableView.deselectRow(at: indexPath, animated: true)
            let exercisesTableViewController = ExercisesTableViewController(workoutService: workoutService)
            exercisesTableViewController.delegate = self
            let vc = UINavigationController(rootViewController: exercisesTableViewController)
            self.present(vc, animated: true)
        } else {
            let exercise = template.templateExercises[indexPath.row]
            let exerciseDetailViewController = EditExerciseDetailViewController(exercise: exercise.name, sets: Int(exercise.sets), reps: Int(exercise.reps))
            exerciseDetailViewController.delegate = self
            let vc = UINavigationController(rootViewController: exerciseDetailViewController)
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let isAddButtonRow = indexPath.row == template.templateExercises.count
        guard let section = Section(rawValue: indexPath.section) else { return false }
        
        return section == .exercises && !isAddButtonRow
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let offsetIndexPath = IndexPath(row: indexPath.row, section: 0)
            let exerciseToDelete = fetchedResultsController.object(at: offsetIndexPath)
            workoutService.deleteTemplateExercise(exerciseToDelete)
            updateSaveButton()
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // Restricts cell's reorder destination (i.e. repositioning exercise under "Add Exercise" button)
        let isAddExerciseButtonRow = template.templateExercises.count
        guard let destinationSection = Section(rawValue: proposedDestinationIndexPath.section),
              destinationSection == .exercises,
              proposedDestinationIndexPath.row != isAddExerciseButtonRow
        else { return sourceIndexPath }
        
        return proposedDestinationIndexPath
    }
}


extension TemplateViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        let offsetIndexPath = IndexPath(row: indexPath.row, section: 0)
        let exercise = fetchedResultsController.object(at: offsetIndexPath)
        dragItem.localObject = exercise
        print("timmy drag \(exercise.name)")
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard destinationIndexPath.section != 0 else { return }
        changeIsUserDriven = true
        defer { changeIsUserDriven = false }
        
        workoutService.moveTemplateExercise(from: sourceIndexPath, to: destinationIndexPath, template: template)
        // TODO: Did update template
    }
    
}

extension TemplateViewController: AddExerciseDetailViewControllerDelegate {
    func addExerciseDetailViewControllerDelegate(_ viewController: AddExerciseDetailViewController, didAddExercise exercise: String, sets: Int, reps: Int) {
        guard let exercises = fetchedResultsController.fetchedObjects else { return }
        let sampleExercise = TemplateExercise(context: childContext)
        sampleExercise.name = exercise
        sampleExercise.sets = Int16(sets)
        sampleExercise.reps = Int16(reps)
        sampleExercise.index = Int16(exercises.count)
        sampleExercise.template = template
        template.addToTemplateExercises_(sampleExercise)
                
        updateSaveButton()
    }
    
    func addExerciseDetailViewControllerDelegate(_ viewController: AddExerciseDetailViewController, didDismiss: Bool) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }

}

extension TemplateViewController: EditExerciseDetailViewControllerDelegate {
    func editExerciseDetailViewControllerDelegate(_ viewController: EditExerciseDetailViewController, didUpdateExercise exercise: String, sets: Int, reps: Int) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        let exercise = template.templateExercises[selectedIndexPath.row]
        exercise.sets = Int16(sets)
        exercise.reps = Int16(reps)
        
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        print("Updated \(exercise) \(sets) x \(reps)")
    }
    
    func editExerciseDetailViewControllerDelegate(_ viewController: EditExerciseDetailViewController, didDismiss: Bool) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
}

extension TemplateViewController: TemplateTitleTableViewCellDelegate {
    func templateTitleTableViewCell(_ cell: TemplateTitleTableViewCell, titleTextFieldDidChange title: String) {
        template.title = title
        updateSaveButton()
    }
}

extension TemplateViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {

        guard changeIsUserDriven == false else { return }

        switch type {
        case .insert:
            guard let newIndexPath else { return }
            print("timmy insert: \(IndexPath(row: newIndexPath.row, section: Section.exercises.rawValue))")
            tableView.insertRows(at: [IndexPath(row: newIndexPath.row, section: Section.exercises.rawValue)], with: .fade)

        case .delete:
            guard let indexPath else { return }
            print("timmy delete: \(IndexPath(row: indexPath.row, section: Section.exercises.rawValue))")
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: Section.exercises.rawValue)], with: .fade)

        case .update:
            guard let indexPath else { return }
            print("timmy update: \(IndexPath(row: indexPath.row, section: Section.exercises.rawValue))")
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: Section.exercises.rawValue)], with: .automatic)

        case .move:
            guard let indexPath, let newIndexPath else { return }
            print("timmy move: \(IndexPath(row: indexPath.row, section: Section.exercises.rawValue)) to \(IndexPath(row: newIndexPath.row, section: Section.exercises.rawValue))")
            tableView.moveRow(
                at: IndexPath(row: indexPath.row, section: Section.exercises.rawValue),
                to: IndexPath(row: newIndexPath.row, section: Section.exercises.rawValue)
            )
        @unknown default:
            break
        }
    }
}

extension TemplateViewController: UIAdaptivePresentationControllerDelegate {
    
    // Dismiss modal by swiping (does not trigger by calling dismiss())
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        CoreDataStack.shared.mainContext.rollback()
    }
}
