//
//  SaveNoteOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        
        super.init()
        
        saveToDb.completionBlock = { [weak self] in
            guard let self = self else {
                return
            }
            
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
            backendQueue.addOperation(saveToBackend)
        }
        
        addDependency(saveToDb)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
        guard let saveToBackend = saveToBackend else {
            result = saveToDb.result
            finish()
            return
        }
        
        switch saveToBackend.result {
        case .some(.success):
            result = true
        case .some(.failure(let netError)):
            result = saveToDb.result
            print(netError)
        case .none:
            result = saveToDb.result
        }
        
        finish()
    }
}

