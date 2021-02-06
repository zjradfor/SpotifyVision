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
    // MARK: - UI Constants
    
    private enum Dimensions {
        enum ButtonStack {
            static let centerYMargin: CGFloat = -45
        }
        
        enum ControlButtons {
            static let width: CGFloat = 80
            static let height: CGFloat = 80
        }
    }
    
    // MARK: - UI Elements
    
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
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [previousButton, playButton, nextButton])
        stackView.distribution = .equalSpacing
        stackView.spacing = 48
        
        return stackView
    }()

    // MARK: - Properties

    weak var delegate: PlayerControlViewDelegate?
    
    // MARK: Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .darkGrayColor

        addSubviews()
        addConstraints()
    }
    
    // MARK: - Methods
    
    func updateUI(isPlaying: Bool) {
        let controlImage: UIImage? = isPlaying ? SFSymbols.pause.build() : SFSymbols.play.build()

        playButton.setImage(controlImage, for: .normal)
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
        addSubview(buttonStack)
    }
    
    func addConstraints() {
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
