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
    
    var title: String {
        switch self {
        case .badRequest: return "Server Error"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .tooManyRequests: return "Rate Limited"
        case .generalError: return "Error"
            
        default: return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .badRequest,
             .generalError: return "Something went wrong, please try again later."
        case .unauthorized: return "You are not authorized with Spotify."
        case .forbidden: return "Services not available."
        case .tooManyRequests: return "You've exceeded the current number of requests, please try again later."
            
        default: return "Something went wrong, please try again later."
        }
    }
}
