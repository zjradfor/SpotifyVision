//
//  PlayerControlView.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-12-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

// MARK: -

protocol PlayerControlViewDelegate: AnyObject {
    func didPressPlayButton()
    func didPressNextButton()
    func didPressPreviousButton()
}

// MARK: -

class PlayerControlView: UIView {
    // MARK: - Constants
    
    private enum Dimensions {
        enum TrackLabel {
            static let topMargin: CGFloat = 20
            static let leftMargin: CGFloat = 25
            static let rightMargin: CGFloat = -25
        }
        
        enum ButtonStack {
            static let centerYMargin: CGFloat = -45
        }
        
        enum ControlButtons {
            static let width: CGFloat = 80
            static let height: CGFloat = 80
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: PlayerControlViewDelegate?
    
    // MARK: - UI Elements
    
    private var trackLabel: UILabel = {
        let label = UILabel()
        label.text = "NOTHING_PLAYING".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private var playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = SFSymbols.play.build()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var previousButton: UIButton = {
        let button = UIButton(type: .system)
        let image = SFSymbols.previous.build()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let image = SFSymbols.next.build()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.spacing = 36
        
        return stackView
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .darkGrayColor
        
        setUp()
        
        trackLabel.isHidden = true // TODO
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        addConstraints()
    }
    
    // MARK: - Methods
    
    func updateUI(isPlaying: Bool, trackName: String?) {
        let controlImage: UIImage? = isPlaying ? SFSymbols.pause.build() : SFSymbols.play.build()

        playButton.setImage(controlImage, for: .normal)
        trackLabel.text = trackName ?? "NOTHING_PLAYING".localized
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

extension PlayerControlView: Constructible {
    func addSubviews() {
        buttonStack.addArrangedSubview(previousButton)
        buttonStack.addArrangedSubview(playButton)
        buttonStack.addArrangedSubview(nextButton)
        
        addSubview(trackLabel)
        addSubview(buttonStack)
    }
    
    func addConstraints() {
        trackLabel.activateConstraints([
            trackLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Dimensions.TrackLabel.leftMargin),
            trackLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.TrackLabel.rightMargin),
            trackLabel.topAnchor.constraint(equalTo: topAnchor, constant: Dimensions.TrackLabel.topMargin)
        ])
        
        buttonStack.activateConstraints([
            buttonStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Dimensions.ButtonStack.centerYMargin),
            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor)
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
