//
//  AuthenticationViewController+WKNavigationDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/11/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import WebKit
import CocoaLumberjack

extension AuthenticationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        /// Stop auth if internet connection is lost
        guard UserSettings.shared.isInternetConnectionOn else {
            decisionHandler(.cancel)
            dismiss(animated: true, completion: nil)
            return
        }
        
        let request = navigationAction.request
        if let url = request.url {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            
            guard let components = URLComponents(string: targetString) else { return }
            
            if !haveCode, let code = components.queryItems?.first (where: { $0.name == "code" })?.value {
                self.code = code
                haveCode = true
            }
        }
        do {
            decisionHandler(.allow)
        }
    }
}
