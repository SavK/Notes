//
//  AuthenticationViewController+CustomMethos.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/11/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

extension AuthenticationViewController {
    
    func setupWebView() {
        view.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }
    
    func setupLoadAuthenticationViewIndicator() {
        view.addSubview(loadAuthenticationViewIndicator)
        loadAuthenticationViewIndicator.center = view.center
        loadAuthenticationViewIndicator.startAnimating()
    }
}
