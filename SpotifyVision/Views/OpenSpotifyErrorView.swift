//
//  OpenSpotifyErrorView.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-09-07.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

// MARK: -

protocol OpenSpotifyErrorViewDelegate: AnyObject {
    func didPressCloseError()
    func didPressOpenSpotify()
}

// MARK: -

class OpenSpotifyErrorView: UIView {
    // MARK: - Constants
    
    private enum Dimensions {
        enum ContainerView {
            static let height: CGFloat = 225
            static let leftMargin: CGFloat = 10
            static let rightMargin: CGFloat = -10
        }
        
        enum CloseButton {
            static let height: CGFloat = 25
            static let width: CGFloat = 25
            static let topMargin: CGFloat = 12
            static let rightMargin: CGFloat = -12
        }
        
        enum TitleLabel {
            static let topMargin: CGFloat = 60
        }
        
        enum MessageLabel {
            static let topMargin: CGFloat = 8
        }
        
        enum OpenButton {
            static let height: CGFloat = 48
            static let topMargin: CGFloat = 24
            static let rightMargin: CGFloat = -12
            static let leftMargin: CGFloat = 12
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: OpenSpotifyErrorViewDelegate?
    
    private var hasSpotifyInstalled: Bool {
        guard let url = URL(string: "spotify:") else { return false }
        
        return UIApplication.shared.canOpenURL(url)
    }
    
    // MARK: - UI Elements
    
    private var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NO_PLAYER_FOUND_TITLE".localized
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        return label
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "NO_PLAYER_FOUND_MESSAGE".localized
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: .closeSymbol)
        let whiteImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(whiteImage, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private var openButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: .closeSymbol)
        button.setTitle("OPEN_SPOTIFY".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .spotifyGreen
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(openButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        addConstraints()
        
        openButton.isHidden = !hasSpotifyInstalled
        
        animateViewIn()
    }
    
    // MARK: - Methods
    
    private func animateViewIn() {
        containerView.transform = CGAffineTransform(translationX: 0, y: 500)
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.1,
            options: .curveEaseOut,
            animations: {
                self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc
    private func closeButtonPressed() {
        delegate?.didPressCloseError()
    }
    
    @objc
    private func openButtonPressed() {
        delegate?.didPressOpenSpotify()
    }
}

extension OpenSpotifyErrorView: Constructible {
    func addSubviews() {
        addSubview(dimView)
        addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(openButton)
    }
    
    func addConstraints() {
        dimView.pinEdges(to: self)
        
        containerView.activateConstraints([
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: Dimensions.ContainerView.leftMargin),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: Dimensions.ContainerView.rightMargin),
            containerView.heightAnchor.constraint(equalToConstant: Dimensions.ContainerView.height)
        ])
        
        closeButton.activateConstraints([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Dimensions.CloseButton.topMargin),
            closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: Dimensions.CloseButton.rightMargin),
            closeButton.heightAnchor.constraint(equalToConstant: Dimensions.CloseButton.height),
            closeButton.widthAnchor.constraint(equalToConstant: Dimensions.CloseButton.width)
        ])
        
        titleLabel.activateConstraints([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Dimensions.TitleLabel.topMargin)
        ])
        
        messageLabel.activateConstraints([
            messageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Dimensions.MessageLabel.topMargin)
        ])
        
        openButton.activateConstraints([
            openButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Dimensions.OpenButton.topMargin),
            openButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: Dimensions.OpenButton.rightMargin),
            openButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Dimensions.OpenButton.leftMargin),
            openButton.heightAnchor.constraint(equalToConstant: Dimensions.OpenButton.height)
        ])
    }
}
