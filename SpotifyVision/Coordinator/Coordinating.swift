//
//  Coordinating.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2021-02-12.
//  Copyright © 2021 Zach Radford. All rights reserved.
//

import UIKit

protocol Coordinating {
    init(navigationController: UINavigationController)
    var navigationController: UINavigationController { get }
    func start()
}
