//
//  PlayerView.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-29.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import SDWebImage
import UIKit

// MARK: -

protocol PlayerViewDelegate: AnyObject {
    func didPressPlayButton()
    func didPressNextButton()
    func didPressPreviousButton()
    func didPressRecentlyPlayed()
}

// MARK: -

class PlayerView: UIView {
    // MARK: - Constants
    
    private enum Dimensions {
        enum AlbumImage {
            static let width: CGFloat = 450
            static let height: CGFloat = 450
        }
        
        enum ControlView {
            static let height: CGFloat = 290
        }
        
        enum CurrentDeviceLabel {
            static let topMargin: CGFloat = 50
        }
        
        enum RecentlyPlayedButton {
            static let width: CGFloat = 44
            static let height: CGFloat = 44
            static let bottomMargin: CGFloat = -50
            static let rightMargin: CGFloat = -20
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: PlayerViewDelegate?
    
    // MARK: - UI Elements
    
    private var albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "album-placeholder")
        imageView.layer.cornerRadius = Dimensions.AlbumImage.height / 2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var controlView: PlayerControlView = {
        let view = PlayerControlView()
        view.layer.cornerRadius = 22
        
        return view
    }()
    
    private var currentDeviceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private var recentlyPlayedButton: UIButton = {
        let button = UIButton(type: .system)
        let image = SFSymbols.list.build()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(recentlyPlayedButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .lightGrayColor
        
        setUp()
        
        controlView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        addConstraints()
    }
    
    // MARK: - Methods
    
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?, deviceName: String?) {
        controlView.updateUI(isPlaying: isPlaying, trackName: trackName)
        
        albumImage.sd_setImage(with: albumImageURL, placeholderImage: UIImage(named: "album-placeholder"))
        currentDeviceLabel.text = "CURRENTLY_PLAYING_ON".localized + "\n \(deviceName ?? "")"
        
        if isPlaying {
            albumImage.rotate360Degrees()
        } else {
            albumImage.layer.removeAllAnimations()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func recentlyPlayedButtonPressed() {
        delegate?.didPressRecentlyPlayed()
    }
}

// MARK: - PlayerControlViewDelegate

extension PlayerView: PlayerControlViewDelegate {
    func didPressPlayButton() {
        delegate?.didPressPlayButton()
    }
    
    func didPressNextButton() {
        delegate?.didPressNextButton()
    }
    
    func didPressPreviousButton() {
        delegate?.didPressPreviousButton()
    }
}

// MARK: -

extension PlayerView: Constructible {
    func addSubviews() {
        addSubview(albumImage)
        addSubview(controlView)
        addSubview(currentDeviceLabel)
        addSubview(recentlyPlayedButton)
    }
    
    func addConstraints() {
        albumImage.activateConstraints([
            albumImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumImage.widthAnchor.constraint(equalToConstant: Dimensions.AlbumImage.width),
            albumImage.heightAnchor.constraint(equalToConstant: Dimensions.AlbumImage.height)
        ])
        
        controlView.activateConstraints([
            controlView.bottomAnchor.constraint(equalTo: bottomAnchor),
            controlView.leftAnchor.constraint(equalTo: leftAnchor),
            controlView.rightAnchor.constraint(equalTo: rightAnchor),
            controlView.heightAnchor.constraint(equalToConstant: Dimensions.ControlView.height)
        ])
        
        currentDeviceLabel.activateConstraints([
            currentDeviceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentDeviceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.CurrentDeviceLabel.topMargin)
        ])
        
        recentlyPlayedButton.activateConstraints([
            recentlyPlayedButton.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.RecentlyPlayedButton.rightMargin),
            recentlyPlayedButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Dimensions.RecentlyPlayedButton.bottomMargin),
            recentlyPlayedButton.widthAnchor.constraint(equalToConstant: Dimensions.RecentlyPlayedButton.width),
            recentlyPlayedButton.heightAnchor.constraint(equalToConstant: Dimensions.RecentlyPlayedButton.height)
        ])
    }
}
