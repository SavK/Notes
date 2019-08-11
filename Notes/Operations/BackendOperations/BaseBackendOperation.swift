//
//  BaseBackendOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

class BaseBackendOperation: AsyncOperation {
    let apiGitHubURL = "https://api.github.com/gists"
    
    override init() {
        super.init()
    }
}
