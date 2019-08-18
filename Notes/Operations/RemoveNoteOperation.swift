//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData

class RemoveNoteOperation: AsyncOperation {
    
    // MARK: - Private Properties
    private let note: Note
    private var saveToBackend: SaveNotesBackendOperation
    private let removeFromDb: RemoveNoteDBOperation
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        self.note = note
        
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        removeFromDb = RemoveNoteDBOperation(note: note,
                                             notebook: notebook,
                                             context: backgroundContext)
        
        
        
        super.init()
        /// Save to backend after note was removed
        removeFromDb.completionBlock = {
            self.saveToBackend.notes = notebook.notes
            backendQueue.addOperation(self.saveToBackend)
        }
        /// Run Operation after dependencies
        addDependency(removeFromDb)
        addDependency(saveToBackend)
        
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        defer { finish() }
        
        if isCancelled { return }
    }
}

