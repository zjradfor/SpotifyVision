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
}

// MARK: -

class PlayerView: UIView {
    // MARK: - Constants
    
    private enum Dimensions {
        enum AlbumImage {
            static let width: CGFloat = 450
            static let height: CGFloat = 450
        }
        
        enum ContainerView {
            static let height: CGFloat = 160
            static let leftMargin: CGFloat = 20
            static let rightMargin: CGFloat = -20
        }
        
        enum TrackLabel {
            static let topMargin: CGFloat = 20
            static let leftMargin: CGFloat = 25
            static let rightMargin: CGFloat = -25
        }
        
        enum ButtonStack {
            static let centerYMargin: CGFloat = 20
        }
        
        enum ControlButtons {
            static let width: CGFloat = 50
            static let height: CGFloat = 50
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
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.85)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private var trackLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing Playing"
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()

    private var playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: .playSymbol)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var previousButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: .previousSymbol)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: .nextSymbol)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        return stackView
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .spotifyBlack
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        addConstraints()
    }
    
    // MARK: - Methods
    
    func updateUI(isPlaying: Bool, trackName: String?, albumImageURL: URL?) {
        let playButtonImageType: String = isPlaying ? .pauseSymbol : .playSymbol
        let playButtonImage = UIImage(systemName: playButtonImageType)
        
        playButton.setImage(playButtonImage, for: .normal)
        trackLabel.text = trackName ?? "Nothing Playing"
        albumImage.sd_setImage(with: albumImageURL, placeholderImage: UIImage(named: "album-placeholder"))
        
        if isPlaying {
            albumImage.rotate360Degrees()
        } else {
            albumImage.layer.removeAllAnimations()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func playButtonPressed() {
        delegate?.didPressPlayButton()
    }
    
    @objc
    private func previousButtonPressed() {
        delegate?.didPressPreviousButton()
    }
    
    @objc
    private func nextButtonPressed() {
        delegate?.didPressNextButton()
    }
}

// MARK: -

extension PlayerView: Constructible {
    func addSubviews() {
        buttonStack.addArrangedSubview(previousButton)
        buttonStack.addArrangedSubview(playButton)
        buttonStack.addArrangedSubview(nextButton)
        
        addSubview(albumImage)
        addSubview(containerView)
        containerView.addSubview(trackLabel)
        containerView.addSubview(buttonStack)
    }
    
    func addConstraints() {
        albumImage.activateConstraints([
            albumImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumImage.widthAnchor.constraint(equalToConstant: Dimensions.AlbumImage.width),
            albumImage.heightAnchor.constraint(equalToConstant: Dimensions.AlbumImage.height)
        ])
        
        containerView.activateConstraints([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: Dimensions.ContainerView.leftMargin),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.ContainerView.rightMargin),
            containerView.heightAnchor.constraint(equalToConstant: Dimensions.ContainerView.height)
        ])
        
        trackLabel.activateConstraints([
            trackLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Dimensions.TrackLabel.leftMargin),
            trackLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: Dimensions.TrackLabel.rightMargin),
            trackLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Dimensions.TrackLabel.topMargin)
        ])
        
        buttonStack.activateConstraints([
            buttonStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: Dimensions.ButtonStack.centerYMargin),
            buttonStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        previousButton.activateConstraints([
            previousButton.widthAnchor.constraint(equalToConstant: Dimensions.ControlButtons.width),
            previousButton.heightAnchor.constraint(equalToConstant: Dimensions.ControlButtons.height)
        ])
        
        playButton.activateConstraints([
            playButton.widthAnchor.constraint(equalToConstant: Dimensions.ControlButtons.width),
            playButton.heightAnchor.constraint(equalToConstant: Dimensions.ControlButtons.height)
        ])
        
        nextButton.activateConstraints([
            nextButton.widthAnchor.constraint(equalToConstant: Dimensions.ControlButtons.width),
            nextButton.heightAnchor.constraint(equalToConstant: Dimensions.ControlButtons.height)
        ])
    }
}
