//
//  AppDelegate.swift
//  WorkoutApp
//
//  Created by Timmy Nguyen on 12/31/23.
//

import UIKit
import CoreData
import WatchConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var sessionDelegator: SessionDelegator = {
        return SessionDelegator()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        WCSession.default.delegate = sessionDelegator
        WCSession.default.activate()
        
        printLocalizable()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// sucode swiftui exanded calendar

var words = """
-
%@
%@ %@
%lld %@
%lld Workouts
%lldx%d %@ at %@
+%@ %@
+0 %@
Accent Color
Add Exercise
Add Set
Alphabetical (A-Z)
Appearance
Are you sure you want to delete %@
Automatic
Best: %@ %@
blue
brown
Bug Report
Cancel
Contact Us
Create Workout
Custom
cyan
Dark
Data Privacy
Date
Delete Log?
Delete Template?
Delete Workout
Edit Workout
Exercises
Finish
General
green
Haptic Feedback
Help & Support
indigo
Latest: %@ %@
Light
Log
Metric (kg)
mint
No Email Account Found
OK
orange
pink
Position
PREVIOUS
Privacy
Privacy Policy
Progress
purple
Push Day
Recently Updated
red
Remove
REPS
Search Exercises
SET
Settings
Show Timer
Sort By
teal
Theme
There is no email account associated to this device. If you have any questions, please feel free to reach out to us at %@
Time
Title
Updated: %@
US/Imperial (lbs)
Weight
Weight Unit
Weight Units
white
Workout
yellow
Your workout data is locally stored on your device, ensuring complete privacy. No one else can access or view your data, guaranteeing the confidentiality of your personal fitness data.
"""

func printLocalizable() {
    if let url = Bundle.main.url(forResource: "Localizable", withExtension: "xcstrings"),
        let stringsDict = NSDictionary(contentsOf: url) as? [String: Any] {
        print(stringsDict)
    } else {
        print("fail")
    }
}


var keyWords: String {
    words.replacingOccurrences(of: " : {", with: "")
        .replacingOccurrences(of: "   \"", with: "")
        .replacingOccurrences(of: "\"\n\n    },", with: "")
        .replacingOccurrences(of: "\"\n\n    }", with: "")
}



//Translate the following list of strings for an iOS gym application into {LANGUAGE}. Provide the result with the english word followed by a "-" and then the {LANGUAGE} equivalent. 

