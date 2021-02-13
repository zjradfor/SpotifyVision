//
//  AuthenticationWebViewController.swift
//  SpotifyVision
//
//  Created by Zach Radford on 2020-07-27.
//  Copyright © 2020 Zach Radford. All rights reserved.
//

import UIKit
import WebKit

class AuthenticationWebViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel = AuthenticationWebViewModel(title: "LOGIN_TO_SPOTIFY".localized, urlString: .spotifyURL)
    private let webView = WKWebView()
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        title = viewModel.title
        view = webView

        makeRequest()
    }
    
    // MARK: - Methods
    
    private func makeRequest() {
        if let url = URL(string: viewModel.urlString) {
            let request = URLRequest(url: url)
            
            webView.load(request)
        }
    }
    
    private func handleWebCallback(request: URLRequest) {
        guard let url = request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            let queryItems = urlComponents.queryItems else {
            return
        }
        
        if let code = queryItems.filter({ item in item.name == "code" }).first?.value {
            viewModel.getToken(with: code) { result in
                if result {
                    self.notificationCenter.post(name: .didAuthenticate, object: nil)
                    self.dismiss(animated: true)
                } else {
                    // error?
                }
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension AuthenticationWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        handleWebCallback(request: navigationAction.request)
        decisionHandler(.allow)
    }
}
