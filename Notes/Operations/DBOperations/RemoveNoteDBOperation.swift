//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData
import CocoaLumberjack

class RemoveNoteDBOperation: BaseDBOperation {
    
    // MARK: - Private Properties
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook,
         context: NSManagedObjectContext) {
        
        self.note = note
        super.init(notebook: notebook, backgroundContext: context)
    }
    
    override func main() {
        notebook.remove(noteWith: note.uid)
        /// Find Note with uid, and delete if it is
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid = %@", note.uid)
        
        backgroundContext.performAndWait {
            do {
                let notes = try backgroundContext.fetch(request)
                if notes.count > 0 {
                    notes.forEach { backgroundContext.delete($0) }
                }
                /// Save context without note with the received identifier
                try backgroundContext.save()
            } catch {
                let saveError = error as NSError
                DDLogError("Save after removing ERROR: \(saveError), \(saveError.userInfo)")
            }
        }
        finish()
    }
}
