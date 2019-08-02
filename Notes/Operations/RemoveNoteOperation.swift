//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    
    // MARK: Private Properties
    private let note: Note
    private var saveToBackend: SaveNotesBackendOperation
    private let removeFromDb: RemoveNoteDBOperation
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        self.note = note
        
        removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook)
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        
        
        super.init()
        
        removeFromDb.completionBlock = {
            backendQueue.addOperation(self.saveToBackend)
        }
        
        addDependency(removeFromDb)
        addDependency(saveToBackend)
        
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        defer { finish() }
        
        if isCancelled { return }
    }
}

