//
//  PlayerService.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-26.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

extension Services {
    static func getCurrentPlayer(completion: @escaping (Result<CurrentlyPlaying?, APIError>) -> ()) {
        URLSession.shared.request(baseURL + "/player", method: .GET, headers: header) { result in
            if case let .success(data) = result {
                let player = try? JSONDecoder().decode(CurrentlyPlaying.self, from: data)
                
                completion(.success(player))
            }

            if case let .failure(error) = result {
                completion(.failure(error))
            }
        }
    }
    
    static func playMusic(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(baseURL + "/player/play", method: .PUT, headers: header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    static func pauseMusic(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(baseURL + "/player/pause", method: .PUT, headers: header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    static func skipToNext(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(baseURL + "/player/next", method: .POST, headers: header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    static func skipToPrevious(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(baseURL + "/player/previous", method: .POST, headers: header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
}
