//
//  SpotifyURL.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

fileprivate enum Scope: String {
    case readPrivate = "user-read-private"
    case readEmail = "user-read-email"
    case modifyLibrary = "user-library-modify"
    case readLibrary = "user-library-read"
    case streaming = "streaming"
    case modifyPlayback = "user-modify-playback-state"
    case readPlayback = "user-read-playback-state"
    
    static func string(with scopes: [Scope]) -> String {
        return String(scopes.reduce("") { "\($0) \($1.rawValue)" }.dropFirst())
    }
}

extension String {
    static var spotifyURL: String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = "/authorize"
        
        let scopes: [Scope] = [
            .readPrivate, .readEmail, .modifyLibrary, .modifyPlayback,
            .readLibrary, .streaming, .modifyPlayback, .readPlayback
        ]
        
        components.queryItems = [
            URLQueryItem(name: "redirect_uri", value: SpotifyCredentials().redirectURI),
            URLQueryItem(name: "client_id", value: SpotifyCredentials().clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Scope.string(with: scopes))
        ]
        
        return components.string ?? ""
    }
}
