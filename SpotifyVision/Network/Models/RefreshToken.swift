//
//  RefreshToken.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-26.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

struct RefreshToken: Decodable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
