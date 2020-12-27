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
        case .badRequest: return "SERVER_ERROR_TITLE".localized
        case .unauthorized: return "UNAUTHORIZED_ERROR_TITLE".localized
        case .forbidden: return "FORBIDDEN_ERROR_TITLE".localized
        case .tooManyRequests: return "RATE_LIMITED_ERROR_TITLE".localized
        case .generalError: return "GENERAL_ERROR_TITLE".localized
            
        default: return "GENERAL_ERROR_TITLE".localized
        }
    }
    
    var message: String {
        switch self {
        case .badRequest,
             .generalError: return "GENERAL_ERROR_MESSAGE".localized
        case .unauthorized: return "UNAUTHORIZED_ERROR_MESSAGE".localized
        case .forbidden: return "FORBIDDEN_ERROR_MESSAGE".localized
        case .tooManyRequests: return "RATE_LIMITED_ERROR_MESSAGE".localized
            
        default: return "GENERAL_ERROR_MESSAGE".localized
        }
    }
}
