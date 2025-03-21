//
//  Utility.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 3/19/25.
//

import Foundation

extension String {
    // note: using .localized will not automically update Localizable.xcstrings. Using String(localized:) does.
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
    
    func localized(_ args: CVarArg...) -> String {
        let format = String(localized: String.LocalizationValue(self))
        return String(format: format, arguments: args)
    }
}
