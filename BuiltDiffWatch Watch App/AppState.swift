//
//  AppState.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/6/25.
//

import Foundation
import SwiftUI
import WatchConnectivity
import Combine

@Observable class AppState {
    var color: Color = .blue
    var weightUnit: WeightType = .lbs
    var navigationPath = NavigationPath()
    let command: Command = .updateAppContext
    
    // This doesn't work. WCSession may not yet be fully activated. Use onAppear()
//    init() {
//        updateWithInitialState()
//        NotificationCenter.default.addObserver(self, selector: #selector(dataDidFlow), name: .dataDidFlow, object: nil)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .dataDidFlow, object: nil)
//    }
    
    /**
     Update the user interface with the command status.
     There isn't a timed color when the app initially loads the interface.
     */
    func updateUI(with commandStatus: CommandStatus, errorMessage: String? = nil) {
        guard let userInfo = commandStatus.userInfo else { return }
        color = Color(uiColor: userInfo.color)
        weightUnit = userInfo.weightType
    }
    
    /**
     Update the view with the initial session state.
     */
    func updateWithInitialState() {
        if command == .updateAppContext {
            let mostRecentAppContext: [String: Any] = WCSession.default.receivedApplicationContext
            
            if !mostRecentAppContext.isEmpty {
                var commandStatus = CommandStatus(command: command, phrase: .received)
                commandStatus.userInfo = UserInfo(mostRecentAppContext)
                updateUI(with: commandStatus)
            }
            return
        }
    }
    
    @objc func dataDidFlow(_ notification: Notification) {
        guard let commandStatus = notification.object as? CommandStatus else { return }
        /**
         If the data is from the current channel, update the color and timestamp.
         */
        if commandStatus.command == command {
            updateUI(with: commandStatus, errorMessage: commandStatus.errorMessage)
            return
        }
    }
}


extension NotificationCenter {
    var dataDidFlowPublisher: Publishers.ReceiveOn<NotificationCenter.Publisher, DispatchQueue> {
        return publisher(for: .dataDidFlow).receive(on: .main)
    }
}
