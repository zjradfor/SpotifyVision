//
//  APIError.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

enum APIError: Error {
    case badRequest //400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case tooManyRequests // 429
    
    case generalError
}
