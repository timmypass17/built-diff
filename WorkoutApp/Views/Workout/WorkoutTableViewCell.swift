//
//  WorkoutTableViewCell.swift
//  WorkoutApp
//
//  Created by Timmy Nguyen on 12/31/23.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    static let reuseIdentifier = "WorkoutCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "a.circle.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let textContainer: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        return vstack
    }()
    
    private let container: UIStackView = {
        let hstack = UIStackView()
        hstack.translatesAutoresizingMaskIntoConstraints = false
        hstack.axis = .horizontal
        hstack.alignment = .center
        hstack.spacing = 8
        return hstack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        textContainer.addArrangedSubview(titleLabel)
        textContainer.addArrangedSubview(descriptionLabel)
        container.addArrangedSubview(iconImageView)
        container.addArrangedSubview(textContainer)
        
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(template: Template) {
        titleLabel.text = template.title // "\(template.title) \(template.index)"
        descriptionLabel.text = template.templateExercises.map { $0.name }.joined(separator: ", ")
        updateIcon(letter: template.title.first?.lowercased() ?? "a")
    }
    
    private func updateIcon(letter: String) {
        var config = UIImage.SymbolConfiguration(pointSize: 35)
        config = config.applying(UIImage.SymbolConfiguration(paletteColors: [.white, Settings.shared.selectedAccentColor]))

        let userLanguage = Locale.preferredLanguages.first ?? "en"

        let iconName: String
        if userLanguage.starts(with: "en") {
            iconName = "\(letter).circle.fill"
        } else {
            iconName = "figure.strengthtraining.traditional.circle.fill"
        }

        iconImageView.image = UIImage(systemName: iconName, withConfiguration: config)
    }
}
