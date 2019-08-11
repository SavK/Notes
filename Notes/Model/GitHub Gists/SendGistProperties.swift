//
//  SendGistProperties.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/9/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

struct SendGistProperties: Codable {
    let gistsDescription: String
    let gistsPublic: Bool
    let files: [String: FileContent]
    
    enum CodingKeys: String, CodingKey {
        case gistsDescription = "description"
        case gistsPublic = "public"
        case files
    }
}
