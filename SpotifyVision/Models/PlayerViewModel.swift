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
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?, deviceName: String?)
    func showError(_ error: APIError)
}

// MARK: -

class PlayerViewModel {
    // MARK: - Properties
    
    weak var delegate: PlayerViewModelDelegate?
    
    var isPlaying: Bool = false
    
    private var durationTimer: Timer?
    
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
                        albumImageURL: albumImageURL,
                        deviceName: currentlyPlaying.device.name
                    )
                    
                    guard let trackDuration = currentlyPlaying.item?.duration,
                        let progress = currentlyPlaying.progress else { return }
                    
                    let timeRemaining = (trackDuration - progress).msToSeconds
                    strongSelf.startTimer(for: timeRemaining)
                    
                case .failure(let error):
                    strongSelf.delegate?.showError(error)
                }
            }
        }
    }
    
    func playMusic() {
        provider.playMusic { [weak self] error in
            guard let strongSelf = self else { return }

            if let error = error {
                strongSelf.delegate?.showError(error)
            } else {
                strongSelf.getCurrentlyPlaying()
            }
        }
    }
    
    func pauseMusic() {
        provider.pauseMusic { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.delegate?.showError(error)
            } else {
                strongSelf.getCurrentlyPlaying()
            }
        }
    }
    
    func skipToNextSong() {
        provider.skipToNext { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.delegate?.showError(error)
            } else {
                strongSelf.getCurrentlyPlaying()
            }
        }
    }
    
    func skipToPreviousSong() {
        provider.skipToPrevious { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.delegate?.showError(error)
            } else {
                strongSelf.getCurrentlyPlaying()
            }
        }
    }
    
    private func startTimer(for seconds: Double) {
        durationTimer?.invalidate()
        
        durationTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.getCurrentlyPlaying()
        }
    }
}
