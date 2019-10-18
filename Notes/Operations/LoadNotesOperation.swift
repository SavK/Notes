//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class LoadNotesOperation: AsyncOperation {
    
    // MARK: - Private Properties
    private var loadFromBackend: LoadNotesBackendOperation
    private var loadFromDb: LoadNotesDBOperation
    private var notebook: FileNotebook
    
    private(set) var result: [Note]? = []
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        loadFromBackend = LoadNotesBackendOperation()
        loadFromDb = LoadNotesDBOperation(notebook: notebook,
                                          backgroundContext: backgroundContext)
        
        self.notebook = notebook
        super.init()
        
        loadFromDb.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            self.addDependency(self.loadFromBackend)
        }
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
            DDLogDebug("loading backend SUCCESS")
        default:
            result = loadFromDb.result
            DDLogDebug("loading DB SUCCESS")
        }
    }
}
