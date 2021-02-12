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

    // MARK: - Initialization

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        navigationController.isNavigationBarHidden = true
    }

    // MARK: - Methods

    /// TODO: Create a router to handle navigation
    func start() {
        showPlayerView()
    }

    private func showPlayerView() {
        let vc = PlayerViewController()
        vc.coordinator = self

        navigationController.pushViewController(vc, animated: false)
    }

    func showRecentlyPlayedView() {
        let vc = RecentlyPlayedViewController()
        let nav = UINavigationController(rootViewController: vc)

        navigationController.present(nav, animated: true)
    }
}
