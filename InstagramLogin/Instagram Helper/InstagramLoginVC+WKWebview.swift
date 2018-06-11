//
//  InstagramLoginVC+WKWebview.swift
//  Capchur
//
//  Created by Hitesh Surani on 01/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//



// MARK: - WKNavigationDelegate

import WebKit
import UIKit

extension InstagramSharedVC: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if navigationItem.title == nil {
            navigationItem.title = webView.title
        }
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url?.absoluteString, let range = url.range(of: "#access_token=") {
            instaCompltionHand!(String(url[range.upperBound...]),nil)
        }
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let response = navigationResponse.response as? HTTPURLResponse, response.statusCode == 400 {
            instaCompltionHand!(nil,InstagramError(kind: .invalidRequest, message: "Invalid request"))
        }
        
        decisionHandler(.allow)
    }
}
