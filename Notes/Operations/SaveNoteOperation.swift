//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData

class SaveNoteOperation: AsyncOperation {
    
    // MARK: - Private Properties
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        self.note = note
        self.notebook = notebook
        
        saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
        saveToDb = SaveNoteDBOperation(note: note,
                                       notebook: notebook,
                                       context: backgroundContext)
        
        
        super.init()
        
        saveToDb.completionBlock = {
            self.saveToBackend.notes = notebook.notes
            backendQueue.addOperation(self.saveToBackend)
        }
        
        addDependency(saveToDb)
        addDependency(saveToBackend)
        dbQueue.addOperation(saveToDb)
    }

    override func main() {
        defer { finish() }
        
        if isCancelled { return }
        
        if let result = saveToBackend.result {
            switch result {
            case .success:
                self.result = true
            case .failure:
                self.result = false
            }
        }
    }
}

