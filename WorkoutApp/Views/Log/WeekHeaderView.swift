//
//  WeekHeaderView.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 3/19/25.
//

import UIKit

class WeekHeaderView: UIView {

    static let reuseIdentifier = "WeekHeaderView"

    let dayViews: [DayView] = (0..<7).map { _ in DayView() }

    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var workoutService: WorkoutService?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dayViews.forEach { view in
            container.addArrangedSubview(view)
        }
        
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
//        container.layer.borderColor = UIColor.blue.cgColor
//        container.layer.borderWidth = 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func update() {
        let weekDays = getWeekDays()
        let startOfWeek: Date = weekDays[0]
        let endOfWeek: Date = weekDays[weekDays.count - 1]
        
        let weekLogs: [Workout] = workoutService?.fetchLogs(from: startOfWeek, to: endOfWeek) ?? []
        let loggedDates: Set<Date> = Set(weekLogs.map { Calendar.current.startOfDay(for: $0.createdAt) })

        for (index, dayView) in dayViews.enumerated() {
            dayView.update(
                date: weekDays[index],
                isCompleted: loggedDates.contains( weekDays[index])
            )
        }
    }

    // Returns an array of days starting from Sunday (first day of the week)
    private func getWeekDays() -> [Date] {
        let calendar = Calendar.current
        let today = Date()

        // Find the Sunday of the current week
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today

        // Generate an array of days for the week (Sunday to Saturday)
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: startOfWeek)! }
    }
}

extension Date {
    var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}

class DayView: UIView {
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let circleBackgroundView: UIView = {
        let circle = UIView()
        circle.layer.cornerRadius = 20
//        circle.backgroundColor = .systemBlue
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container.addArrangedSubview(dayLabel)
        container.addArrangedSubview(valueLabel)
        addSubview(circleBackgroundView)  // Add the circle behind the labels

        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            circleBackgroundView.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor),
            circleBackgroundView.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            circleBackgroundView.widthAnchor.constraint(equalToConstant: 40),
            circleBackgroundView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
        
//        container.layer.borderColor = UIColor.orange.cgColor
//        container.layer.borderWidth = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(date: Date, isCompleted: Bool) {
        dayLabel.text = date.weekday
        valueLabel.text = "\(date.day)"
        
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(date)
        
        // Show a ring if it's today
        if isCompleted {
//            circleBackgroundView.layer.borderWidth = 3
//            circleBackgroundView.layer.borderColor = Settings.shared.selectedAccentColor.cgColor
            circleBackgroundView.backgroundColor = Settings.shared.selectedAccentColor
            valueLabel.textColor = .white
//            circleBackgroundView.alpha = 0.9
        } else if isToday {
            circleBackgroundView.layer.borderWidth = 3
            circleBackgroundView.layer.borderColor = Settings.shared.selectedAccentColor.cgColor
            circleBackgroundView.alpha = 0.9
            circleBackgroundView.backgroundColor = .clear
            valueLabel.textColor = .label
        } else {
            // Default background for other days
            circleBackgroundView.layer.borderWidth = 3
            circleBackgroundView.layer.borderColor = UIColor.secondarySystemFill.cgColor
            circleBackgroundView.backgroundColor = .clear
            valueLabel.textColor = .label
        }
    }
}

//#Preview {
//    let dayView = DayView()
//    dayView.update(date: .now)
//    return dayView
//}
//
//#Preview {
//    let view = WeekHeaderView()
//    return view
//}
