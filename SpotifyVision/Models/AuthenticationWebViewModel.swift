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
    
    private let provider: AuthorizationProvider
    
    // MARK: - Initialization
    
    init(title: String, urlString: String, provider: AuthorizationProvider = AuthorizationService()) {
        self.title = title
        self.urlString = urlString
        self.provider = provider
    }
    
    // MARK: - Methods
    
    func getToken(with code: String, completion: @escaping (Bool) -> ()) {
        provider.getToken(with: code) { result in
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
