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
    private let converter: Converter
    
    init(note: Note,
         notebook: FileNotebook,
         context: NSManagedObjectContext) {
        
        self.note = note
        self.converter = Converter(object: note)
        super.init(notebook: notebook, backgroundContext: context)
    }
    
    override func main() {
        
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid = %@", note.uid)
        
        notebook.add(note: note)
        backgroundContext.performAndWait {
            do {
                /// Find Note with uid, and delete if it is
                let notes = try backgroundContext.fetch(request)
                if notes.count > 0 { backgroundContext.delete(notes.first!) }
                /// Create new note for DB
                converter.convertObjectToCoreData(forContext: backgroundContext)
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
