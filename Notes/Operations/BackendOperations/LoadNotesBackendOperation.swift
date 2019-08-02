//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    private(set) var result: LoadNotesBackendResult?
    
    override func main() {
        result = .failure(.unreachable)
        DDLogDebug("Load from backend ERROR: \(String(describing: result))")
        finish()
    }
}
