//
//  Track.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-09-05.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

struct Track: Decodable {
    let artists: [Artist]
    let name: String
    let album: Album
    let duration: Int
    
    enum CodingKeys: String, CodingKey {
        case artists
        case name
        case album
        case duration = "duration_ms"
    }
}
