//
//  UserDefaultsExtensions.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

extension UserDefaults {
    var accessToken: String? {
        get {
            string(forKey: .accessTokenKey)
        } set {
            set(newValue, forKey: .accessTokenKey)
        }
    }
    
    var refreshToken: String? {
        get {
            string(forKey: .refreshTokenKey)
        } set {
            set(newValue, forKey: .refreshTokenKey)
        }
    }
}

private extension String {
    static let accessTokenKey = "kAccessTokenKey"
    static let refreshTokenKey = "kRefreshTokenKey"
}
