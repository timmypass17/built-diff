//
//  LogTableViewCell.swift
//  WorkoutApp
//
//  Created by Timmy Nguyen on 1/17/24.
//

import UIKit

class LogViewCell: UITableViewCell {
    static let reuseIdentifier = "LogTableViewCell"
    
    private let leftIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.isHidden = true
        return view
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let workoutLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private let exercisesLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 4
        return label
    }()
    
    private let dateVStackView: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.alignment = .center
        return vstack
    }()
    
    private let workoutVStackView: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        return vstack
    }()
    
    private let containerHStackView: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.alignment = .top
        hstack.spacing = 8
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(leftIndicatorView)

        // Setup constraints for leftIndicatorView
        NSLayoutConstraint.activate([
            leftIndicatorView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            leftIndicatorView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            leftIndicatorView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            leftIndicatorView.widthAnchor.constraint(equalToConstant: 3)
        ])

        dateVStackView.addArrangedSubview(weekdayLabel)
        dateVStackView.addArrangedSubview(dayLabel)

        workoutVStackView.addArrangedSubview(workoutLabel)
        workoutVStackView.addArrangedSubview(exercisesLabel)
        
        containerHStackView.addArrangedSubview(dateVStackView)
        containerHStackView.addArrangedSubview(workoutVStackView)
        
        contentView.addSubview(containerHStackView)
        
        NSLayoutConstraint.activate([
            dateVStackView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            containerHStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            containerHStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            containerHStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerHStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(workout: Workout) {
        guard let createdAt = workout.createdAt_ else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        weekdayLabel.text = dateFormatter.string(from: createdAt)
        dayLabel.text = "\(Calendar.current.component(.day, from: createdAt))"
        // TODO: local
        workoutLabel.text = workout.title
        exercisesLabel.text = workout.getExercises()
            .compactMap { exercise in
                guard let bestSet = exercise.bestSet else { return nil }
                let weightString: String
                if Settings.shared.weightUnit == .lbs {
                    weightString = bestSet.weight.lbsString
                } else {
                    weightString = bestSet.weight.kgString
                }                
                
                return "\(exercise.getExerciseSets().count)x\(exercise.maxReps ?? 0) \(exercise.name) - \(weightString) \(Settings.shared.weightUnit.shortDescription)"
            }
            .joined(separator: "\n")

        // Check if workout date is today
        if Calendar.current.isDateInToday(createdAt) {
            leftIndicatorView.isHidden = false
            leftIndicatorView.backgroundColor = Settings.shared.selectedAccentColor
        } else {
            leftIndicatorView.isHidden = true
        }
    }
}
