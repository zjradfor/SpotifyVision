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
    func updateUI(isPlaying: Bool, trackName: String?, artists: [Artist], album: Album, deviceName: String?)
    func showError(_ error: APIError)
}

// MARK: -

class PlayerViewModel {
    // MARK: - Properties
    
    weak var delegate: PlayerViewModelDelegate?
    var isPlaying: Bool = false

    private let provider: PlayerProvider

    private var trackDurationTimer: Timer?
    
    // MARK: - Initialization
    
    init(provider: PlayerProvider = PlayerService()) {
        self.provider = provider
    }
    
    // MARK: - Methods

    /// Delay getting the current player to allow other actions to be synced on Spotify
    /// NOTE: The player API is flakey and isn't always return the correct values
    func getCurrentlyPlaying() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.provider.getCurrentPlayer { [weak self] result in
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let successResult):
                    guard let currentlyPlaying = successResult,
                        let currentItem = currentlyPlaying.item else { return }
                    
                    strongSelf.isPlaying = currentlyPlaying.isPlaying
                    
                    strongSelf.delegate?.updateUI(
                        isPlaying: currentlyPlaying.isPlaying,
                        trackName: currentItem.name,
                        artists: currentItem.artists,
                        album: currentItem.album,
                        deviceName: currentlyPlaying.device.name
                    )

                    strongSelf.startTrackDurationTimer(
                        progress: currentlyPlaying.progress,
                        duration: currentItem.duration
                    )
                    
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
    
    private func startTrackDurationTimer(progress: Int?, duration: Int) {
        guard let progress = progress else { return }
        let seconds = (duration - progress).msToSeconds

        trackDurationTimer?.invalidate()
        
        trackDurationTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.getCurrentlyPlaying()
        }
    }
}
