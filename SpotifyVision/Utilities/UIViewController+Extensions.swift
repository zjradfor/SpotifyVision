//
//  UIViewController+Extensions.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-09-06.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String?,
        message: String?,
        handler: ((UIAlertAction) -> Void)? = nil,
        additionalAction: UIAlertAction? = nil
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
            if let action = additionalAction {
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
