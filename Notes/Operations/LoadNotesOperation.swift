//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LoadNotesOperation: AsyncOperation {
    
    // MARK: Private Properties
    private var loadFromBackend: LoadNotesBackendOperation
    private var loadFromDb: LoadNotesDBOperation
    
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        loadFromBackend = LoadNotesBackendOperation()
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        addDependency(loadFromBackend)
        addDependency(loadFromDb)
        
        dbQueue.addOperation(loadFromBackend)
        backendQueue.addOperation(loadFromDb)
    }
    
    override func main() {
        defer { finish() }
        
        if isCancelled { return }
        
        switch loadFromBackend.result {
        case .some(.success(let notes)):
            result = notes
        default:
            DDLogError("loading backend ERROR: start load from DB")
            result = loadFromDb.result
        }
    }
}
