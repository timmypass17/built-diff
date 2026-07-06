//
//  AccentColorTableViewController.swift
//  WorkoutApp
//
//  Created by Timmy Nguyen on 2/23/24.
//

import UIKit

protocol AccentColorTableViewControllerDelegate: AnyObject {
    func accentColorTableViewController(_ controller: AccentColorTableViewController, didSelectAccentColor color: UIColor, colorName: String?)
}

class AccentColorTableViewController: UITableViewController {

    let colors: [AccentColor] = AccentColor.allCases
    weak var delegate: AccentColorTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ColorCell")
        tableView.register(CustomColorTableViewCell.self, forCellReuseIdentifier: CustomColorTableViewCell.reuseIdentifier)

        navigationItem.title = String(localized: "Accent Color")
        navigationItem.largeTitleDisplayMode = .never
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).dataDidFlow(_:)),
            name: .dataDidFlow, object: nil
        )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomColorTableViewCell.reuseIdentifier, for: indexPath) as! CustomColorTableViewCell
            cell.delegate = self
            cell.update(selectedColor: Settings.shared.selectedAccentColor)
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath)
        let color = colors[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = color.description
        cell.contentConfiguration = content
        cell.accessoryType = color == Settings.shared.accentColor ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedColor = colors[indexPath.row]
        Settings.shared.accentColor = selectedColor
        Settings.shared.customAccentColor = nil
        NotificationCenter.default.post(name: AccentColor.valueChangedNotification, object: nil)
        delegate?.accentColorTableViewController(self, didSelectAccentColor: selectedColor.color, colorName: selectedColor.rawValue.capitalized)
        tableView.reloadData()
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: selectedColor.color, requiringSecureCoding: false)
        guard let colorData = data else { fatalError("Failed to archive a UIColor!") }
                
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())
        
        let appContext: [String: Any] = [
            PayloadKey.timeStamp: timeString,
            PayloadKey.colorData: colorData,
            PayloadKey.weightType: Settings.shared.weightUnit.rawValue
        ]
                
        updateAppContext(appContext)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 0 ? nil : indexPath
    }
    
    @objc
    func dataDidFlow(_ notification: Notification) {
        guard let commandStatus = notification.object as? CommandStatus else { return }
        
//        defer { noteLabel.isHidden = logView.text.isEmpty ? false: true }
//        
        // If an error occurs, show the error message and return.
        if let errorMessage = commandStatus.errorMessage {
            print("! \(commandStatus.command.rawValue)...\(errorMessage)")
            return
        }
        
        guard let userInfo = commandStatus.userInfo else { return }
        // TODO: If watch updated, update iOS app here
        print("#\(commandStatus.command.rawValue)...\n\(commandStatus.phrase.rawValue) at \(userInfo.timeStamp)\nColor: \(userInfo.color)\nWeight Type: \(userInfo.weightType.fullDescription)")
        
    }
}

enum AccentColor: String, CaseIterable, Codable {
    case blue, red, orange, yellow, green, purple, pink, mint, cyan, teal, indigo, brown, white
    static let valueChangedNotification = Notification.Name("AccentColor.valueChanged")

    var color: UIColor {
        switch self {
        case .red:
            return .systemRed
        case .orange:
            return .systemOrange
        case .yellow:
            return .systemYellow
        case .green:
            return .systemGreen
        case .blue:
            return .systemBlue
        case .purple:
            return .systemPurple
        case .pink:
            return .systemPink
        case .mint:
            return .systemMint
        case .cyan:
            return .systemCyan
        case .teal:
            return .systemTeal
        case .indigo:
            return .systemIndigo
        case .brown:
            return .systemBrown
        case .white:
            return .white
        }
    }
    
    var description: String {
        switch self {
        case .blue:
            return String(localized: "blue")
        case .red:
            return String(localized: "red")
        case .orange:
            return String(localized: "orange")
        case .yellow:
            return String(localized: "yellow")
        case .green:
            return String(localized: "green")
        case .purple:
            return String(localized: "purple")
        case .pink:
            return String(localized: "pink")
        case .mint:
            return String(localized: "mint")
        case .cyan:
            return String(localized: "cyan")
        case .teal:
            return String(localized: "teal")
        case .indigo:
            return String(localized: "indigo")
        case .brown:
            return String(localized: "brown")
        case .white:
            return String(localized: "white")
        }
    }
}

extension AccentColorTableViewController: CustomColorTableViewCellDelegate {
    func customColorTableViewCell(_ cell: CustomColorTableViewCell, didSelectCustomColor color: UIColor) {
        cell.update(selectedColor: color)
        Settings.shared.accentColor = nil
        Settings.shared.customAccentColor = CodableUIColor(color: color)
        NotificationCenter.default.post(name: AccentColor.valueChangedNotification, object: nil)
        delegate?.accentColorTableViewController(self, didSelectAccentColor: color, colorName: nil)
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        
        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        guard let colorData = data else { fatalError("Failed to archive a UIColor!") }
                
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        let timeString = dateFormatter.string(from: Date())
        
        let appContext: [String: Any] = [
            PayloadKey.timeStamp: timeString,
            PayloadKey.colorData: colorData,
            PayloadKey.weightType: Settings.shared.weightUnit.rawValue
        ]
        
        updateAppContext(appContext)
    }
}

extension AccentColorTableViewController: TestDataProvider, SessionCommands {

}
