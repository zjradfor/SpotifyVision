//
//  PlayerService.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-26.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

// MARK: -

protocol PlayerProvider {
    func getCurrentPlayer(completion: @escaping (Result<CurrentlyPlaying?, APIError>) -> ())
    func playMusic(completion: @escaping (APIError?) -> ())
    func pauseMusic(completion: @escaping (APIError?) -> ())
    func skipToNext(completion: @escaping (APIError?) -> ())
    func skipToPrevious(completion: @escaping (APIError?) -> ())
    func getRecentlyPlayed(completion: @escaping (Result<PlayHistory?, APIError>) -> ())
}

// MARK: -

class PlayerService: PlayerProvider {
    func getCurrentPlayer(completion: @escaping (Result<CurrentlyPlaying?, APIError>) -> ()) {
        URLSession.shared.request(Services.baseURL + "/player", method: .GET, headers: Services.header) { result in
            if case let .success(data) = result {
                let player = try? JSONDecoder().decode(CurrentlyPlaying.self, from: data)
                
                completion(.success(player))
            }

            if case let .failure(error) = result {
                completion(.failure(error))
            }
        }
    }
    
    func playMusic(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(Services.baseURL + "/player/play", method: .PUT, headers: Services.header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func pauseMusic(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(Services.baseURL + "/player/pause", method: .PUT, headers: Services.header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func skipToNext(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(Services.baseURL + "/player/next", method: .POST, headers: Services.header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func skipToPrevious(completion: @escaping (APIError?) -> ()) {
        URLSession.shared.request(Services.baseURL + "/player/previous", method: .POST, headers: Services.header) { result in
            if case let .failure(error) = result {
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    func getRecentlyPlayed(completion: @escaping (Result<PlayHistory?, APIError>) -> ()) {
        URLSession.shared.request(Services.baseURL + "/player/recently-played", method: .GET, headers: Services.header) { result in
            if case let .success(data) = result {
                let items = try? JSONDecoder().decode(PlayHistory.self, from: data)
                
                completion(.success(items))
            }

            if case let .failure(error) = result {
                completion(.failure(error))
            }
        }
    }
}
