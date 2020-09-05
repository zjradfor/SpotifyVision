//
//  AuthToken.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-24.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

struct AuthToken: Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
