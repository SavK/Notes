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
        if let controller = segue.destination as? EditNoteViewController, segue.identifier == "showEditView" {
            if let index = selectedIndex {
                controller.title = "Изменение заметки"
                controller.note = notebook.notes[flipCellIndex(index)]
                
            } else {
                controller.title = "Создание заметки"
            }
            controller.delegate = self
        }
    }
}
