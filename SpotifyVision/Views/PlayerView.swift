//
//  PlayerView.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-29.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

// MARK: -

protocol PlayerViewDelegate: AnyObject {
    func didPressPlayButton()
    func didPressNextButton()
    func didPressPreviousButton()
}

// MARK: -

class PlayerView: UIView {
    // MARK: - Properties
    
    weak var delegate: PlayerViewDelegate?
    
    // MARK: - UI Elements
    
    private var albumImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private var trackLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a sample thing playing"
        
        return label
    }()

    private var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let image = UIImage(systemName: "play.circle.fill")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let image = UIImage(systemName: "backward.end.fill")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let image = UIImage(systemName: "forward.end.fill")
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
    
    func updateUI(isPlaying: Bool, trackName: String, albumImageURL: URL) {
        let playButtonImageType = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        let playButtonImage = UIImage(systemName: playButtonImageType)
        
        playButton.setImage(playButtonImage, for: .normal)
        trackLabel.text = trackName
        albumImage.loadImage(from: albumImageURL)
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

// MARK: - Constructible

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
            albumImage.widthAnchor.constraint(equalToConstant: 400),
            albumImage.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        containerView.activateConstraints([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        trackLabel.activateConstraints([
            trackLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trackLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        
        buttonStack.activateConstraints([
            buttonStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 20),
            buttonStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
