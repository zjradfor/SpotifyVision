//
//  UIImageViewExtensions.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-08-03.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                strongSelf.image = image
            }
        }
    }
}
