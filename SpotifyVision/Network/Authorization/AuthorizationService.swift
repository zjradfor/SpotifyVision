//
//  AuthorizationService.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-26.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

extension Services {
    private static var authorizationHeader: HTTPRequestHeaders {
        let clientID = SpotifyCredentials().clientID
        let clientSecret = SpotifyCredentials().clientSecret
        guard let data = "\(clientID):\(clientSecret)".data(using: .utf8) else { return [:] }

        return ["Authorization" : "Basic \(data.base64EncodedString(options: []))"]
    }
    
    static func getToken(with code: String, completion: @escaping (Result<AuthToken, APIError>) -> ()) {
        let parameters: HTTPRequestParameters = ["client_id": SpotifyCredentials().clientID,
                                                 "client_secret": SpotifyCredentials().clientSecret,
                                                 "grant_type": "authorization_code",
                                                 "code": code,
                                                 "redirect_uri": SpotifyCredentials().redirectURI]
        
        URLSession.shared.request("https://accounts.spotify.com/api/token", method: .POST, parameters: parameters) { result in
            if case let .success(data) = result,
                let token = try? JSONDecoder().decode(AuthToken.self, from: data) {
                
                completion(.success(token))
            } else if case let .failure(error) = result {
                completion(.failure(error))
            }
        }
    }
    
    static func refreshToken(completion: @escaping (Bool) -> ()) {
        guard let refreshToken = UserDefaults.standard.refreshToken else {
            completion(false)
            return
        }
        
        let parameters: HTTPRequestParameters = ["grant_type":"refresh_token", "refresh_token": refreshToken]
        
        URLSession.shared.request("https://accounts.spotify.com/api/token", method: .POST, parameters: parameters, headers: authorizationHeader) { result in
            if case let .success(data) = result {
                let token = try? JSONDecoder().decode(RefreshToken.self, from: data)
                
                UserDefaults.standard.accessToken = token?.accessToken
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
