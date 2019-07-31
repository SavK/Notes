//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool = false
    
    init(note: Note, notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        removeFromDb = RemoveNoteDBOperation(note: note, notebook: notebook)
        
        super.init()
        
        removeFromDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
            backendQueue.addOperation(saveToBackend)
        }
        
        addDependency(removeFromDb)
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        guard let saveToBackend = saveToBackend else {
            result = removeFromDb.result
            finish()
            return
        }
        
        switch saveToBackend.result {
        case .some(.success):
            result = true
        case .some(.failure(let netError)):
            result = removeFromDb.result
            print(netError)
        case .none:
            result = removeFromDb.result
        }
        
        finish()
    }
}

