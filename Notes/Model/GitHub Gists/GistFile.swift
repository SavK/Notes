//
//  GistFile.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/8/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

struct GistFile: Codable {
    let language: String?
    let filename: String
    let rawUrl: String
    let type: String
    let size: Int
}
