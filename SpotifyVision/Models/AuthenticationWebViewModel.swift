//
//  AuthenticationWebViewModel.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import Foundation

class AuthenticationWebViewModel {
    // MARK: - Properties

    private let userDefaults = UserDefaults.standard
    private let provider: AuthorizationProvider

    var title: String
    var urlString: String
    
    // MARK: - Initialization
    
    init(title: String, urlString: String, provider: AuthorizationProvider = AuthorizationService()) {
        self.title = title
        self.urlString = urlString
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func getToken(with code: String, completion: @escaping (Bool) -> Void) {
        provider.getToken(with: code) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let token):
                strongSelf.userDefaults.accessToken = token.accessToken
                strongSelf.userDefaults.refreshToken = token.refreshToken
                
                completion(true)
                
            case .failure:
                completion(false)
            }
        }
    }
}
