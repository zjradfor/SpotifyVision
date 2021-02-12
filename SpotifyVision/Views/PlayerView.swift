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
    }

    private let coinUpPosition: CGFloat = 200
    
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

    // MARK: - Properties

    private var coinViewIsDown: Bool = true

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

        moveCoinViewButton.transform = .identity
        albumImage.transform = .identity
        coinViewIsDown = true
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

    private func animateCoinViewPosition() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: [.curveEaseInOut]) {
            var newValue: CGFloat = 0

            if self.coinViewIsDown {
                newValue = self.coinDownPosition
                self.albumImage.transform = .identity
            } else {
                newValue = self.coinUpPosition
                self.albumImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }

            self.albumImage.center = CGPoint(x: self.albumImage.center.x, y: newValue)
        }

        /// Rotate chevron button to reflect the action direction
        moveCoinViewButton.transform = moveCoinViewButton.transform.rotated(by: .pi)
    }
    
    // MARK: - Actions

    @objc
    private func moveCoinViewButtonPressed() {
        coinViewIsDown.toggle()
        animateCoinViewPosition()
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

            coinViewIsDown = !isMovingUp

            albumImage.center = CGPoint(x: coinInitialCenter.x, y: distanceToMove)

        case .ended,
             .cancelled:
            /// When the pan gesture is ended or cancelled, move the coin view to rest in either the up or down position
            animateCoinViewPosition()

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
    }
}
