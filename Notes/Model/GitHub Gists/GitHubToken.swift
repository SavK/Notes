//
//  GitHubToken.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/11/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

struct GitHubToken: Codable {
    var access_token: String
    var token_type: String
    var scope: String
}
