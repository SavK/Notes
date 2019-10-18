//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class LoadNotesDBOperation: BaseDBOperation {
    private(set) var result: [Note]?
    
    override func main() {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        var fetchedNotes: [NoteEntity] = []
        
        backgroundContext.performAndWait {
            do {
                fetchedNotes = try backgroundContext.fetch(request)
            } catch {
                let fetchError = error as NSError
                DDLogError("Fetch request ERROR: \(fetchError), \(fetchError.userInfo)")
            }
        }
        
        DDLogDebug("\(fetchedNotes.count) notes was fetched")
        /// Array of parsed Notes from NSManagedObject
        let notes = fetchedNotes.map { $0.noteFromEntity }
        /// Add Notes to FileNotebook
        notes.forEach { notebook.add(note: $0) }
        
        result = notes
        
        finish()
    }
}
