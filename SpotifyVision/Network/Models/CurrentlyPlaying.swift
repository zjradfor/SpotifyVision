//
//  CurrentlyPlaying.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

struct CurrentlyPlaying: Decodable {
    let device: Device
    let repeatState: String
    let shuffleState: Bool
    let context: Context?
    let timestamp: Int
    let progress: Int?
    let isPlaying: Bool
    let item: Track?
    let currentType: String
    
    enum CodingKeys: String, CodingKey {
        case device
        case repeatState = "repeat_state"
        case shuffleState = "shuffle_state"
        case context
        case timestamp
        case progress = "progress_ms"
        case isPlaying = "is_playing"
        case item
        case currentType = "currently_playing_type"
    }
}
