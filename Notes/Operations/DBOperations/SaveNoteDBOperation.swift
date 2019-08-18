//
//  SaveNoteDBOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData
import UIKit
import CocoaLumberjack

class SaveNoteDBOperation: BaseDBOperation {
    
    // MARK: - Private Properties
    private let note: Note
    
    init(note: Note,
         notebook: FileNotebook,
         context: NSManagedObjectContext) {
        
        self.note = note
        super.init(notebook: notebook, backgroundContext: context)
    }
    
    override func main() {
        
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid = %@", note.uid)
        
        notebook.add(note)
        backgroundContext.performAndWait {
            do {
                /// Find Note with uid, and delete if it is
                let notes = try backgroundContext.fetch(request)
                if notes.count > 0 { backgroundContext.delete(notes.first!) }
                /// Create new Note for DB
                let newNote = NoteEntity(context: backgroundContext)
                newNote.title = note.title
                newNote.uid = note.uid
                newNote.content = note.content
                newNote.importance = note.importance
                newNote.selfDestructionDate = note.selfDestructionDate
                
               // if note.color.rgba != UIColor.white.rgba {
                    newNote.color = try? JSONEncoder().encode(note.createColorArray())
                //}
                /// Save Note
                try backgroundContext.save()
            } catch {
                let saveError = error as NSError
                DDLogError("Save after removing ERROR: \(saveError), \(saveError.userInfo)")
            }
        }
        finish()
    }
}
