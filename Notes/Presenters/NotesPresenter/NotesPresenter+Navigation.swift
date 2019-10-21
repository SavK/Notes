//
//  NotesPresenter+Navigation.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Navigation
extension NotesPresenter {
    
    func prepareTransition(for segue: UIStoryboardSegue) {
        if let destination = segue.destination as? EditNoteViewController, segue.identifier == "showEditView" {
            if let index = selectedIndex {
                destination.title = "Изменение заметки"
                destination.note = notes[index]
            } else {
                destination.title = "Создание заметки"
            }
            destination.backgroundContext = backgroundContext
            destination.delegate = self
        }
    }
}
