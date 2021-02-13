//
//  AppCoordinator.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2021-02-12.
//  Copyright © 2021 Zach Radford. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinating {
    // MARK: - Properties

    let navigationController: UINavigationController

    private let userDefaults = UserDefaults.standard

    /// This is set to manage only one popover view at a time, the first will have priority
    private var popOverView: UIView?

    // MARK: - Initialization

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        navigationController.isNavigationBarHidden = true
    }

    // MARK: - Methods

    func start() {
        showPlayerView()

        if userDefaults.accessToken == nil {
            openAuthPage()
        }
    }

    private func openAuthPage() {
        let authVC = AuthenticationWebViewController()
        /// Don't allow the modal to be dismissed by swiping
        authVC.isModalInPresentation = true

        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: authVC)

            self.navigationController.present(nav, animated: true)
        }
    }

    private func showPlayerView() {
        let vc = PlayerViewController()
        vc.coordinator = self

        navigationController.pushViewController(vc, animated: false)
    }

    func showOpenSpotifyErrorView() {
        guard popOverView == nil else { return }

        DispatchQueue.main.async {
            let errorView = OpenSpotifyErrorView()
            errorView.delegate = self

            self.navigationController.view.addSubview(errorView)

            errorView.pinEdges(to: self.navigationController.view)

            self.popOverView = errorView
        }
    }

    func showRecentlyPlayedView() {
        let vc = RecentlyPlayedViewController()
        let nav = UINavigationController(rootViewController: vc)

        navigationController.present(nav, animated: true)
    }
}

// MARK: - OpenSpotifyErrorViewDelegate

extension AppCoordinator: OpenSpotifyErrorViewDelegate {
    func didPressCloseError() {
        popOverView?.removeFromSuperview()
        popOverView = nil
    }

    func didPressOpenSpotify() {
        /// Close the error view after opening the link since there is no completion
        didPressCloseError()

        if let url = URL(string: "https://open.spotify.com") {
            UIApplication.shared.open(url)
        }
    }
}
