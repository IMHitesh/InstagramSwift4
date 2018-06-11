//
//  InstagramLoginVC.swift
//  Capchur
//
//  Created by Hitesh Surani on 01/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import UIKit
import WebKit


typealias InstagramCompletionHandler = ((_ accesstoken:String?,_ error:InstagramError?)->())?



class InstagramSharedVC: UIViewController {

    // MARK: - Properties
    private var client: (id: String, redirectUri: String)
    
    var instaCompltionHand:InstagramCompletionHandler
    
    private var webView: WKWebView!
    private var progressView: UIProgressView?
    private var webViewObservation: NSKeyValueObservation?

    
    
    // MARK: - Public Properties
    
    
    public var scopes: [InstagramScope] = [.basic]
    public var progressViewTintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()

        
        // Initializes progress view
        setupProgressView()
        
        // Initializes web view
        setupWebView()
        
        // Starts authorization
        loadAuthorizationURL()
    }
    
    fileprivate func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))
    }

    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let progressView = progressView { progressView.removeFromSuperview() }
        if let webViewObservation = webViewObservation { webViewObservation.invalidate() }
        
    }

    
    private func setupProgressView() {
        if let navBar = navigationController?.navigationBar {
            let progressView = UIProgressView(progressViewStyle: .bar)
            progressView.progress = 0.0
            progressView.tintColor = progressViewTintColor
            
            navBar.addSubview(progressView)
            
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor).isActive = true
            progressView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor).isActive = true
            progressView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            self.progressView = progressView
        }
    }
    
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        if progressView != nil {
            webViewObservation = webView.observe(\.estimatedProgress, changeHandler: progressViewChangeHandler)
        }
    }
    
    
    private func progressViewChangeHandler<Value>(webView: WKWebView, change: NSKeyValueObservedChange<Value>) {
        progressView!.alpha = 1.0
        progressView!.setProgress(Float(webView.estimatedProgress), animated: true)
        
        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.progressView!.alpha = 0.0
            }, completion: { (_ finished) in
                self.progressView!.progress = 0
            })
        }
    }
    
    // MARK: -
    
    private func loadAuthorizationURL() {
        var components = URLComponents(string: "https://api.instagram.com/oauth/authorize/")!
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: client.id),
            URLQueryItem(name: "redirect_uri", value: client.redirectUri),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: scopes.joined(separator: "+"))
        ]
        
        webView.load(URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }
    
    // MARK: - Public methods
    
    public func reloadPage(fromOrigin: Bool = false) {
        let _ = fromOrigin ? webView.reloadFromOrigin() : webView.reload()
    }
    
    public init(clientId: String, redirectUri: String,completionHandler:InstagramCompletionHandler) {
        self.client.id = clientId
        self.client.redirectUri = redirectUri
        instaCompltionHand = completionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
