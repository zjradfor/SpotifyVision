//
//  PlayHistory.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-09-07.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

struct PlayHistory: Decodable {
    let items: [PlayHistoryItem]
}
