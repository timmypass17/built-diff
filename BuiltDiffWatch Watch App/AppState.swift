//
//  AppState.swift
//  BuiltDiffWatch Watch App
//
//  Created by Timmy Nguyen on 3/6/25.
//

import Foundation
import SwiftUI

@Observable class AppState {
    var color: Color = .blue
    var weightUnit: WeightType = .lbs
//    var isPresentingSuccessAlert = false
}
