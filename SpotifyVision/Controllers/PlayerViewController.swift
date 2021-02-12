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

    var coordinator: AppCoordinator?
    
    private let viewModel = PlayerViewModel()
    private let playerView = PlayerView()
    private var openSpotifyErrorView: OpenSpotifyErrorView?
    
    private let userDefaults = UserDefaults.standard
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Lifecyle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self

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
        let authVC = AuthenticationWebViewController()
        authVC.didClose = updatePlayState
        authVC.isModalInPresentation = true
        
        let nav = UINavigationController(rootViewController: authVC)
        
        present(nav, animated: true, completion: nil)
    }
    
    private func askToOpenSpotify() {
        guard openSpotifyErrorView == nil else { return }
        
        DispatchQueue.main.async {
            let errorView = OpenSpotifyErrorView()
            errorView.delegate = self
            
            self.view.addSubview(errorView)
            
            errorView.pinEdges(to: self.view)
            
            self.openSpotifyErrorView = errorView
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
    
    func didPressRecentlyPlayed() {
        coordinator?.showRecentlyPlayedView()
    }
}

// MARK: - OpenSpotifyErrorViewDelegate

extension PlayerViewController: OpenSpotifyErrorViewDelegate {
    func didPressCloseError() {
        openSpotifyErrorView?.removeFromSuperview()
        openSpotifyErrorView = nil
    }
    
    func didPressOpenSpotify() {
        didPressCloseError()
        
        if let url = URL(string: "https://open.spotify.com") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - PlayerDelegate

extension PlayerViewController: PlayerViewModelDelegate {
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?, deviceName: String?) {
        playerView.updateUI(
            isPlaying: isPlaying,
            trackName: trackName,
            albumImageURL: albumImageURL,
            deviceName: deviceName
        )
    }
    
    func showError(_ error: APIError) {
        switch error {
        case .notFound:
            askToOpenSpotify()
        default:
            print(error)
            showAlert(title: error.title, message: error.message)
        }
    }
}
