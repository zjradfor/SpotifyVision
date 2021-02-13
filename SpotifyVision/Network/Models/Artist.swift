//
//  Artist.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2021-02-13.
//  Copyright © 2021 Zach Radford. All rights reserved.
//

import Foundation

struct Artist: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
