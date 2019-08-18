//
//  AuthenticationViewController+Requests.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/11/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

extension AuthenticationViewController {
    
    var codeGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize")
            else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(info.clientId)"),
            URLQueryItem(name: "scope", value: "gist")]
        
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func postRequest() {
        var components = URLComponents(string: "https://github.com/login/oauth/access_token")
        components?.queryItems = [URLQueryItem(name: "client_id", value: info.clientId),
                                  URLQueryItem(name: "client_secret", value: info.clientSecret),
                                  URLQueryItem(name: "code", value: code)]
        
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {  (data, response, error) in
            
            if data != nil {
                guard let newFiles = try? JSONDecoder().decode(GitHubToken.self, from: data!) else { return }
                self.info.token = newFiles.access_token
                self.delegate?.handleTokenChanged(token: newFiles.access_token)
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
}
