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
        
        if UserDefaults.standard.accessToken == nil {
            openAuthPage()
        } else {
            updatePlayState()
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
        authVC.isModalInPresentation = true
        
        let nav = UINavigationController(rootViewController: authVC)
        
        present(nav, animated: true, completion: nil)
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
    func updateUI(isPlaying: Bool, trackName: String, albumImageURL: URL) {
        playerView.updateUI(isPlaying: isPlaying, trackName: trackName, albumImageURL: albumImageURL)
    }
    
    func showError(_ error: APIError) {
        print(error)
    }
    
    func openSpotify() {
        //        let url = URL(string: "spotify:")
        //        print(UIApplication.shared.canOpenURL(url!))
        //
        //        UIApplication.shared.open(URL(string: "https://open.spotify.com")!)
    }
}
