//
//  TrackLabelView.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2021-02-14.
//  Copyright © 2021 Zach Radford. All rights reserved.
//

import MarqueeLabel
import UIKit

class TrackLabelView: UIView {
    // MARK: - UI Constants

    private enum Dimensions {
        enum TrackNameLabel {
            static let height: CGFloat = 28
        }

        enum ArtistNamesLabel {
            static let height: CGFloat = 28
        }
    }

    // MARK: - UI Elements

    private let trackNameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
        label.type = .continuous
        label.animationDelay = 4
        label.speed = .duration(10)
        label.animationCurve = .easeInOut
        label.fadeLength = 10.0

        return label
    }()

    private let artistNamesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)

        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel,
                                                       artistNamesLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 2

        return stackView
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
        backgroundColor = .clear

        addSubviews()
        addConstraints()
    }

    // MARK: - Methods

    func setTrackLabel(trackName: String?, artists: [Artist]) {
        trackNameLabel.text = trackName
        artistNamesLabel.text = createArtistList(artists: artists)
    }

    private func createArtistList(artists: [Artist]) -> String {
        let artistNames = artists.map { $0.name }
        let artistList = artistNames.joined(separator: ", ")

        return artistList
    }
}

// MARK: -

extension TrackLabelView: Constructible {
    func addSubviews() {
        addSubview(labelStackView)
    }

    func addConstraints() {
        labelStackView.pinEdges(to: self)

        trackNameLabel.activateConstraints([
            trackNameLabel.heightAnchor.constraint(equalToConstant: Dimensions.TrackNameLabel.height)
        ])

        artistNamesLabel.activateConstraints([
            artistNamesLabel.heightAnchor.constraint(equalToConstant: Dimensions.ArtistNamesLabel.height)
        ])
    }
}
