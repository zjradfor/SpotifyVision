//
//  String+Extensions.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-08-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

// MARK: - SF Symbols

extension String {
    static let playSymbol = "play.fill"
    static let pauseSymbol = "pause.fill"
    static let nextSymbol = "forward.end.fill"
    static let previousSymbol = "backward.end.fill"
    static let closeSymbol = "xmark.circle.fill"
    static let listSymbol = "list.bullet"
}

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
