//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation?
    
    private(set) var result: [Note] = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        loadFromDb.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation()
            self.loadFromBackend = loadFromBackend
            self.addDependency(loadFromBackend)
            backendQueue.addOperation(loadFromBackend)
        }
        
        addDependency(loadFromDb)
        dbQueue.addOperation(loadFromDb)
    }
    
    override func main() {
        guard let loadFromBackend = loadFromBackend else {
            result = loadFromDb.result
            finish()
            return
        }
        
        switch loadFromBackend.result {
        case .some(.success(let notes)):
            result = notes
        case .some(.failure(let netError)):
            result = loadFromDb.result
            print(netError)
        case .none:
            result = loadFromDb.result
        }
        
        finish()
    }
}
