//
//  NotesTableViewController+CustomMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/22/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Custom Methods
extension NotesTableViewController {
    
    func toggleEditingBarButton(_ button: UIBarButtonItem) {
        if !tableView.isEditing {
            tableView.setEditing(true, animated: true)
            button.title = "Done"
            button.style = .done
        } else {
            tableView.setEditing(false, animated: true)
            button.title = "Edit"
            button.style = .plain
        }
    }
    
    func isNeedEditNotes(_ status: Bool) {
        if !status, tableView.isEditing {
            toggleEditingBarButton(navigationItem.leftBarButtonItem!)
        }
        navigationItem.leftBarButtonItem = status ? leftBarButton : nil
    }
    
    func deleteNoteActivityIndicatorStart() {
        self.deleteNoteActivityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func deleteNoteActivityIndicatorStop() {
        self.deleteNoteActivityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
