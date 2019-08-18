//
//  AuthenticationViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/10/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import WebKit

final class AuthenticationViewController: UIViewController {
    
    // MARK: - Properties
    private var access_token = ""
    
    let webView = WKWebView()
    var info = UserInfo()
    var haveCode = false
    var code: String = "" {
        didSet {
            info.code = self.code
            postRequest()
        }
    }
    weak var delegate: AuthenticationViewControllerDelegate?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        guard let request = codeGetRequest else { return }
        webView.load(request)
        webView.navigationDelegate = self
        /// Stop auth if internet connection is lost
        guard UserSettings.shared.isInternetConnectionOn else {
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = self.view.bounds
    }
}
