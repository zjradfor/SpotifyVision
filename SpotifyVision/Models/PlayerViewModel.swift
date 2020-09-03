//
//  PlayerViewModel.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-08-02.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

// MARK: -

protocol PlayerViewModelDelegate: AnyObject {
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?)
    func showError(_ error: APIError)
}

// MARK: -

class PlayerViewModel {
    // MARK: - Properties
    
    weak var delegate: PlayerViewModelDelegate?
    
    var isPlaying: Bool = false
    
    private let provider: PlayerProvider
    
    // MARK: - Initialization
    
    init(provider: PlayerProvider = PlayerService()) {
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func getCurrentlyPlaying() {
        // Delay getting the current player to allow other actions to be synced on Spotify
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.provider.getCurrentPlayer { [weak self] result in
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let successResult):
                    guard let currentlyPlaying = successResult,
                        let currentTrack = currentlyPlaying.item,
                        let albumImage = currentTrack.album.images.first else { return }
                    
                    let albumImageURL = URL(string: albumImage.url)
                    
                    strongSelf.isPlaying = currentlyPlaying.isPlaying
                    
                    strongSelf.delegate?.updateUI(
                        isPlaying: currentlyPlaying.isPlaying,
                        trackName: currentTrack.name,
                        albumImageURL: albumImageURL
                    )
                    
                case .failure(let error):
                    strongSelf.delegate?.showError(error)
                }
            }
        }
    }
    
    func playMusic() {
        provider.playMusic { [weak self] error in
            if let error = error {
                self?.delegate?.showError(error)
            } else {
                self?.getCurrentlyPlaying()
            }
        }
    }
    
    func pauseMusic() {
        provider.pauseMusic { [weak self] error in
            if let error = error {
                self?.delegate?.showError(error)
            } else {
                self?.getCurrentlyPlaying()
            }
        }
    }
    
    func skipToNextSong() {
        provider.skipToNext { [weak self] error in
            if let error = error {
                self?.delegate?.showError(error)
            } else {
                self?.getCurrentlyPlaying()
            }
        }
    }
    
    func skipToPreviousSong() {
        provider.skipToPrevious { [weak self] error in
            if let error = error {
                self?.delegate?.showError(error)
            } else {
                self?.getCurrentlyPlaying()
            }
        }
    }
}
