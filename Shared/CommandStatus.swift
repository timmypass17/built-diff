/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Wraps the command status.
*/

import UIKit
import WatchConnectivity

// Constants to identify the Watch Connectivity methods, also for user-visible strings in UI.
//
enum Command: String {
    case updateAppContext = "UpdateAppContext"
    case sendMessage = "SendMessage"
    case sendMessageData = "SendMessageData"
    case transferUserInfo = "TransferUserInfo"
    case transferFile = "TransferFile"
    case transferCurrentComplicationUserInfo = "TransferComplicationUserInfo"
}

// Constants to identify the phrases of Watch Connectivity communication.
//
enum Phrase: String {
    case updated = "Updated"
    case sent = "Sent"
    case received = "Received"
    case replied = "Replied"
    case transferring = "Transferring"
    case canceled = "Canceled"
    case finished = "Finished"
    case failed = "Failed"
}

// Wrap a timed color payload dictionary with a stronger type.
//
struct UserInfo {
    var timeStamp: String
    var colorData: Data
    var weightType: WeightType
    
    var color: UIColor {
        let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [UIColor.self], from: colorData)
        guard let color = uiColor as? UIColor else {
            fatalError("Failed to unarchive a UIClor object!")
        }
        return color
    }
    var timedColor: [String: Any] {
        return [PayloadKey.timeStamp: timeStamp, PayloadKey.colorData: colorData]
    }
    
    init(_ userInfo: [String: Any]) {
        // TODO: May make values optional to be more flexible, incase I update this struct with additional values
        guard let timeStamp = userInfo[PayloadKey.timeStamp] as? String,
              let colorData = userInfo[PayloadKey.colorData] as? Data,
              let weightTypeString = userInfo[PayloadKey.weightType] as? String,
              let weightType = WeightType(rawValue: weightTypeString)
        else  {
            fatalError("Timed color dictionary doesn't have right keys!")
        }
        self.timeStamp = timeStamp
        self.colorData = colorData
        self.weightType = weightType
    }
    
    init(_ timedColor: Data) {
        let data = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSString.self, NSData.self], from: timedColor)
        guard let dictionary = data as? [String: Any] else {
            fatalError("Failed to unarchive a timedColor dictionary!")
        }
        self.init(dictionary)
    }
}

enum WeightType: String, CaseIterable, Codable {
    case lbs
    case kg
    
    static let valueChangedNotification = NSNotification.Name("weightTypeChangedNotification")
    
    var shortDescription: String {
        switch self {
        case .lbs:
            return String(localized: "lbs")
        case .kg:
            return String(localized: "kg")
        }
    }
    
    var fullDescription: String {
        switch self {
        case .lbs:
            return String(localized: "US/Imperial (lbs)")
        case .kg:
            return String(localized: "Metric (kg)")
        }
    }
}

// Wrap the command's status to bridge the commands status and UI.
//
struct CommandStatus {
    var command: Command
    var phrase: Phrase
    var userInfo: UserInfo?
    var fileTransfer: WCSessionFileTransfer?
    var file: WCSessionFile?
    var userInfoTranser: WCSessionUserInfoTransfer?
    var errorMessage: String?
    
    init(command: Command, phrase: Phrase) {
        self.command = command
        self.phrase = phrase
    }
}
