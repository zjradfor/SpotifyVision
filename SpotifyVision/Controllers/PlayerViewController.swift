//
//  PlayerViewController.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-06-08.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel: PlayerViewModel!
    
    private var playerView: PlayerView!
    
    private let userDefaults = UserDefaults.standard
    
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Lifecyle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        playerView = PlayerView()
        playerView.delegate = self
        
        view = playerView
        
        notificationCenter.addObserver(
            self,
            selector: #selector(updatePlayState),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if userDefaults.accessToken == nil {
            openAuthPage()
        } else {
            DispatchQueue.main.async {
                self.updatePlayState()
            }
        }
    }
    
    deinit {
        notificationCenter.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    // MARK: - Methods
    
    private func openAuthPage() {
        let authViewModel = AuthenticationWebViewModel(title: "Login", urlString: .spotifyURL)
        let authVC = AuthenticationWebViewController()
        authVC.viewModel = authViewModel
        authVC.didClose = updatePlayState
        authVC.isModalInPresentation = true
        
        let nav = UINavigationController(rootViewController: authVC)
        
        present(nav, animated: true, completion: nil)
    }
    
    private func askToOpenSpotify() {
        guard let url = URL(string: "spotify:") else { return }
        
        let alertController = UIAlertController(title: "No active player found", message: "Start playing something through Spotify!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIApplication.shared.canOpenURL(url) {
            let openAction = UIAlertAction(title: "Open", style: .default) { _ in
                UIApplication.shared.open(URL(string: "https://open.spotify.com")!)
            }
            
            alertController.addAction(openAction)
            alertController.preferredAction = openAction
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Event Handlers
    
    @objc
    private func updatePlayState() {
        viewModel.getCurrentlyPlaying()
    }
}

// MARK: - PlayerViewDelegate

extension PlayerViewController: PlayerViewDelegate {
    func didPressPlayButton() {
        if viewModel.isPlaying {
            viewModel.pauseMusic()
        } else {
            viewModel.playMusic()
        }
    }
    
    func didPressNextButton() {
        viewModel.skipToNextSong()
    }
    
    func didPressPreviousButton() {
        viewModel.skipToPreviousSong()
    }
}

// MARK: - PlayerDelegate

extension PlayerViewController: PlayerViewModelDelegate {
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?) {
        playerView.updateUI(isPlaying: isPlaying, trackName: trackName, albumImageURL: albumImageURL)
    }
    
    func showError(_ error: APIError) {
        switch error {
        case .notFound:
            askToOpenSpotify()
        default:
            print(error)
        }
    }
}
