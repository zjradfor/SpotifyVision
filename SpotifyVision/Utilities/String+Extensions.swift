//
//  String+Extensions.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-08-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

// MARK: Localized

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(withComment: String) -> String {
        return NSLocalizedString(self, comment: withComment)
    }

    func localized(arguments: String...) -> String {
        return String(format: localized, arguments: arguments)
    }
}
