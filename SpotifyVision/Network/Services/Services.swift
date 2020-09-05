//
//  Services.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-26.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

class Services {
    static let baseURL = "https://api.spotify.com/v1/me"
    
    static var header: HTTPRequestHeaders {
        guard let token: String = UserDefaults.standard.accessToken else { return [:] }
        
        return ["Authorization" : "Bearer \(token)"]
    }
}
