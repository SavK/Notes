//
//  NotesPresenter+NoteDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 11/4/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - NoteDelegate
extension NotesPresenter: NoteDelegate {
    
    func addNote(_ note: Note) {
        noteBook.remove(noteWith: note.uid)
        noteBook.add(note: note)
        viewController.updateSelectedRow()
    }
}
