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
    // MARK: - UI Constants
    
    private enum Dimensions {
        enum AlbumImage {
            static let width: CGFloat = 370
            static let height: CGFloat = 370
            static let verticalOffset: CGFloat = -74
        }
        
        enum ControlView {
            static let height: CGFloat = 275
        }
        
        enum CurrentDeviceLabel {
            static let topMargin: CGFloat = 50
        }

        enum MoveCoinViewButton {
            static let width: CGFloat = 44
            static let height: CGFloat = 44
            static let bottomMargin: CGFloat = -12
            static let rightMargin: CGFloat = -30
        }

        enum TrackLabelView {
            static let leftMargin: CGFloat = 80
            static let rightMargin: CGFloat = -80
        }
    }

    /// The coin's up position is halfway between the device label and the track label
    private var coinUpPosition: CGFloat { (currentDeviceLabel.frame.maxY + trackLabelView.frame.minY) / 2 }
    private var coinDownPosition: CGFloat { center.y + Dimensions.AlbumImage.verticalOffset }
    private var coinInitialCenter: CGPoint = .zero
    
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

    private var moveCoinViewButton: UIButton = {
        let button = UIButton(type: .system)
        let image = SFSymbols.chevron.build()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(moveCoinViewButtonPressed), for: .touchUpInside)

        return button
    }()

    private let trackLabelView = TrackLabelView()

    // MARK: - Types

    private enum CoinState {
        case up
        case down

        mutating func toggle() {
            switch self {
            case .up: self = .down
            case .down: self = .up
            }
        }

        var isDown: Bool {
            self == .down
        }
    }

    // MARK: - Properties

    private var coinPosition: CoinState = .down

    weak var delegate: PlayerViewDelegate?
    
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

    override func layoutSubviews() {
        super.layoutSubviews()

        /// Reset view positions
        moveCoinViewButton.transform = .identity
        albumImage.transform = .identity
        coinPosition = .down
    }
    
    // MARK: - Methods
    
    func updateUI(isPlaying: Bool, trackName: String?, artists: [Artist], album: Album, deviceName: String?) {
        controlView.updateUI(isPlaying: isPlaying)
        
        setAlbumImage(album: album)
        currentDeviceLabel.text = "CURRENTLY_PLAYING_ON".localized + "\n \(deviceName ?? "")"
        trackLabelView.setTrackLabel(trackName: trackName, artists: artists)
        
        if isPlaying {
            albumImage.rotate360Degrees()
        } else {
            albumImage.layer.removeAllAnimations()
        }
    }

    private func setAlbumImage(album: Album) {
        let image = album.images.first
        let imageURL = URL(string: image?.url ?? "")

        albumImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "album-placeholder"))
    }

    // MARK: - Animations

    private func animateViewState() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: [.curveEaseInOut]) {
            self.animateCoinViewPosition()
            self.animateCoinViewButton()
        } completion: { _ in
            self.animateTrackLabel()
        }
    }

    private func animateCoinViewPosition() {
        let newValue = coinPosition.isDown ? coinDownPosition : coinUpPosition

        switch coinPosition {
        case .up:
            albumImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        case .down:
            albumImage.transform = .identity
        }

        albumImage.center = CGPoint(x: self.albumImage.center.x, y: newValue)
    }

    private func animateCoinViewButton() {
        switch coinPosition {
        case .up:
            moveCoinViewButton.transform = moveCoinViewButton.transform.rotated(by: .pi)
        case .down:
            moveCoinViewButton.transform = .identity
        }
    }

    private func animateTrackLabel() {
        UIView.animate(withDuration: 0.5) {
            self.trackLabelView.alpha = self.coinPosition.isDown ? 0 : 1
        }
    }
    
    // MARK: - Actions

    @objc
    private func moveCoinViewButtonPressed() {
        coinPosition.toggle()
        animateViewState()
    }

    @objc
    private func coinViewDidPan(_ sender: UIPanGestureRecognizer) {
        /// the amount of "wiggle room" in the gesture
        let threshold: CGFloat = 20

        switch sender.state {
        case .began:
            coinInitialCenter = albumImage.center

        case .changed:
            /// Move the view to follow the users finger but stopping if a max or min is reached
            let translation = sender.translation(in: self)
            let translationDistance = coinInitialCenter.y + translation.y
            let isMovingUp = translationDistance < coinInitialCenter.y
            /// The view will only go as high as the upPosition with a threshold padding
            let distanceUp = max(translationDistance, coinUpPosition - threshold)
            /// The view will only go as low as the downPosition with a threshold padding
            let distanceDown = min(translationDistance, coinDownPosition + threshold)
            let distanceToMove = isMovingUp ? distanceUp : distanceDown

            coinPosition = isMovingUp ? .up : .down

            albumImage.center = CGPoint(x: coinInitialCenter.x, y: distanceToMove)

        case .ended,
             .cancelled:
            /// When the pan gesture is ended or cancelled, move the coin view to rest in either the up or down position
            animateViewState()

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

    func didPressRecentlyPlayed() {
       delegate?.didPressRecentlyPlayed()
   }
}

// MARK: -

extension PlayerView: Constructible {
    func addSubviews() {
        addSubview(albumImage)
        addSubview(controlView)
        addSubview(currentDeviceLabel)
        addSubview(moveCoinViewButton)
        addSubview(trackLabelView)

        bringSubviewToFront(albumImage)
        bringSubviewToFront(moveCoinViewButton)
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

        moveCoinViewButton.activateConstraints([
            moveCoinViewButton.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.MoveCoinViewButton.rightMargin),
            moveCoinViewButton.bottomAnchor.constraint(equalTo: controlView.topAnchor, constant: Dimensions.MoveCoinViewButton.bottomMargin),
            moveCoinViewButton.widthAnchor.constraint(equalToConstant: Dimensions.MoveCoinViewButton.width),
            moveCoinViewButton.heightAnchor.constraint(equalToConstant: Dimensions.MoveCoinViewButton.height)
        ])

        trackLabelView.activateConstraints([
            trackLabelView.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.TrackLabelView.rightMargin),
            trackLabelView.leftAnchor.constraint(equalTo: leftAnchor, constant: Dimensions.TrackLabelView.leftMargin),
            trackLabelView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
