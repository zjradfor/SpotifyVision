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
    
    var viewModel: AuthenticationWebViewModel!
    
    var didClose: (() -> Void)?
    
    private var webView: WKWebView!
    
    // MARK: - Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView?.navigationDelegate = self
        
        title = viewModel.title
        view = webView

        makeRequest()
    }
    
    // MARK: - Methods
    
    private func makeRequest() {
        if let url = URL(string: viewModel.urlString) {
            let request = URLRequest(url: url)
            
            webView?.load(request)
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
                    self.didClose?()
                    self.dismiss(animated: true, completion: nil)
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
