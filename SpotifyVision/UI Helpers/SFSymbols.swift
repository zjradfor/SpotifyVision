//
//  SFSymbols.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2021-01-14.
//  Copyright © 2021 Zach Radford. All rights reserved.
//

import UIKit

enum SFSymbols {
    case play
    case pause
    case next
    case previous
    case close
    case list
    case chevron
    
    private var systemName: String {
        switch self {
        case .play: return "play.circle"
        case .pause: return "pause.circle"
        case .next: return "forward.end"
        case .previous: return "backward.end"
        case .close: return "xmark.circle.fill"
        case .list: return "list.bullet"
        case .chevron: return "chevron.up.circle.fill"
        }
    }
    
    private var defaultPointSize: CGFloat {
        switch self {
        case .play: return 82
        case .pause: return 82
        case .next: return 24
        case .previous: return 24
        case .close: return 16
        case .list: return 24
        case .chevron: return 16
        }
    }
    
    private var defaultWeight: UIImage.SymbolWeight {
        switch self {
        case .play: return .light
        case .pause: return .light
        case .next: return .light
        case .previous: return .light
        case .chevron: return .light
        default: return .unspecified
        }
    }
    
    private var defaultScale: UIImage.SymbolScale {
        switch self {
        default: return .unspecified
        }
    }
    
    private var defaultColor: UIColor {
        switch self {
        default: return .white
        }
    }
    
    func build(pointSize: CGFloat? = nil,
               weight: UIImage.SymbolWeight? = nil,
               scale: UIImage.SymbolScale? = nil,
               color: UIColor? = nil) -> UIImage? {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: pointSize ?? defaultPointSize,
                                                       weight: weight ?? defaultWeight,
                                                       scale: scale ?? defaultScale)
        var image = UIImage(systemName: systemName, withConfiguration: symbolConfig)
        image = image?.withTintColor(color ?? defaultColor, renderingMode: .alwaysOriginal)
        
        return image
    }
}
