//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

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
        
        /// Run loadFromDb if loadFromBackend failure
        loadFromBackend.completionBlock = {
            switch self.loadFromBackend.result {
            case .some(.success(let notes)):
                self.result = notes
            case .some(.failure(let netError)):
                self.result = self.loadFromDb.result
                print(netError)
                backendQueue.addOperation(self.loadFromDb)
            case .none:
                backendQueue.addOperation(self.loadFromDb)
                self.result = self.loadFromDb.result
            }
        }
        
        addDependency(loadFromBackend)
        addDependency(loadFromDb)
        
        dbQueue.addOperation(loadFromBackend)
    }
    
    override func main() {
        if let notes = loadFromDb.result {
            result = notes
        }
        finish()
    }
}
