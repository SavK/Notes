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
    
    /// Request authorization token
    func requestToken() {
        let authenticationViewController = AuthenticationViewController()
        authenticationViewController.delegate = presenter
        authenticationViewController.modalPresentationStyle = .fullScreen
        present(authenticationViewController, animated: false, completion: nil)
    }
    
    func isNeedEditNotes(_ status: Bool) {
        if !status, tableView.isEditing {
            toggleEditingBarButton(navigationItem.leftBarButtonItem!)
        }
        navigationItem.leftBarButtonItem = status ? leftBarButton : nil
    }
    
    /// Update selected row / create new row
    func updateSelectedRow() {
        if let index = presenter.selectedIndex {
            tableView.moveRow(at: IndexPath(row: index, section: 0),
                              to: IndexPath(row: 0, section: 0))
            
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        } else {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
        }
    }
    
    func deleteTableViewRow(atIndex index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
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
    
    func deleteNoteActivityIndicatorStart() {
        self.deleteNoteActivityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func deleteNoteActivityIndicatorStop() {
        self.deleteNoteActivityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
