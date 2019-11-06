//
//  NotesTableViewController+Navigation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Navigation
extension NotesTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditNoteViewController,
            segue.identifier == "showEditView" {
            
            if let index = presenter.selectedIndex {
                destination.title = "Изменение заметки"
                destination.note = presenter.notes[index]
            } else {
                destination.title = "Создание заметки"
            }
            destination.noteBook = presenter.noteBook
            destination.backgroundContext = presenter.backgroundContext
            destination.delegate = presenter
        }
    }
}
