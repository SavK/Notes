//
//  GitHubGist.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/8/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

struct GitHubGist: Codable {
    let files: [String: GistFile]
    let createdAt: Date
    let comments: Int
    let owner: Owner
    let `public`: Bool
    let nodeId: String
    let id: String
}
