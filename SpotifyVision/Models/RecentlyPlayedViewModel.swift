//
//  RecentlyPlayedViewModel.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-09-07.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

class RecentlyPlayedViewModel {
    // MARK: - Properties
    
    var title: String
    
    var items: [PlayHistoryItem]?
    
    private let provider: PlayerProvider
    
    // MARK: - Initialization
    
    init(title: String, provider: PlayerProvider = PlayerService()) {
        self.title = title
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func getRecentlyPlayed(completion: @escaping () -> ()) {
        provider.getRecentlyPlayed { [weak self] result in
            guard let strongSelf = self else { return }
            
            if case let .success(data) = result {
                strongSelf.items = data?.items
                completion()
            }
        }
    }
}
