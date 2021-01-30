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
            static let width: CGFloat = 370
            static let height: CGFloat = 370
            static let verticalOffset: CGFloat = -65
        }
        
        enum ControlView {
            static let height: CGFloat = 275
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

    private var initialCenter: CGPoint = .zero
    private var coinViewIsDown: Bool = true

    weak var delegate: PlayerViewDelegate?
    
    // MARK: - UI Elements
    
    private var albumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "album-placeholder")
        imageView.layer.cornerRadius = Dimensions.AlbumImage.height / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
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

        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .lightGrayColor

        addSubviews()
        addConstraints()

        controlView.delegate = self

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(coinViewDidPan))
        albumImage.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Methods
    
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?, deviceName: String?) {
        controlView.updateUI(isPlaying: isPlaying)
        
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

    @objc
    private func coinViewDidPan(_ sender: UIPanGestureRecognizer) {
        let upPosition: CGFloat = 200
        let downPosition: CGFloat = center.y + Dimensions.AlbumImage.verticalOffset
        /// the amount of "wiggle room" in the gesture
        let threshold: CGFloat = 20

        switch sender.state {
        case .began:
            initialCenter = albumImage.center

        case .changed:
            /// Move the view to follow the users finger but stopping if a max or min is reached
            let translation = sender.translation(in: self)
            let translationDistance = initialCenter.y + translation.y
            let isMovingUp = translationDistance < initialCenter.y
            /// The view will only go as high as the upPosition with a threshold padding
            let distanceUp = max(translationDistance, upPosition - threshold)
            /// The view will only go as low as the downPosition with a threshold padding
            let distanceDown = min(translationDistance, downPosition + threshold)
            let distanceToMove = isMovingUp ? distanceUp : distanceDown

            coinViewIsDown = !isMovingUp

            albumImage.center = CGPoint(x: initialCenter.x, y: distanceToMove)

        case .ended,
             .cancelled:
            /// When the pan gesture is ended or cancelled, move the coin view to rest in either the up or down position
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.7,
                           options: [.curveEaseInOut]) {
                var newValue: CGFloat = 0

                if self.coinViewIsDown {
                    newValue = downPosition
                    self.albumImage.transform = .identity
                } else {
                    newValue = upPosition
                    self.albumImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }

                self.albumImage.center = CGPoint(x: self.initialCenter.x, y: newValue)
            }
        default:
            break
        }
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
            albumImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Dimensions.AlbumImage.verticalOffset),
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
