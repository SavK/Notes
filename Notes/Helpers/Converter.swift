//
//  Converter.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/17/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData
import UIKit
import CocoaLumberjack

class Converter {
    let object: NoteProtocol
    
    init(object: NoteProtocol) {
        self.object = object
    }
    
    /// Create new Note for DB
    func convertObjectToCoreData(forContext context: NSManagedObjectContext) {
        
        let newNote = NoteEntity(context: context)
        newNote.title = object.title
        newNote.uid = object.uid
        newNote.content = object.content
        newNote.importance = object.importance.rawValue
        newNote.selfDestructionDate = object.selfDestructionDate
        
        if object.color.currentColor != UIColor.white {
            do { newNote.color = try JSONEncoder().encode(object.createColorArray())
            } catch { DDLogWarn("Error during converting color for DB model.") }
        }
    }
}
