//
//  AuthenticationWebViewModel.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

struct AuthenticationWebViewModel {
    // MARK: - Properties
    
    var title: String
    
    var urlString: String
    
    // MARK: - Methods
    
    func getToken(with code: String, completion: @escaping (Bool) -> ()) {
        Services.getToken(with: code) { result in
            switch result {
            case .success(let token):
                UserDefaults.standard.accessToken = token.accessToken
                UserDefaults.standard.refreshToken = token.refreshToken
                
                completion(true)
                
            case .failure:
                completion(false)
            }
        }
    }
}
