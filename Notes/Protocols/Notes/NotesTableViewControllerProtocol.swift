//
//  NotesTableViewControllerProtocol.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

protocol NotesTableViewControllerProtocol: UITableViewController {
    
    // MARK: - Properties
    var presenter: NotesPresenterProtocol! { get set }
    var leftBarButton: UIBarButtonItem! { get set }
    var deleteNoteActivityIndicator: UIActivityIndicatorView { get }
    
    // MARK: - Methods
    /// Buttons Methods
    func editButtonTapped(_ sender: UIBarButtonItem)
    func newNoteButtonTapped()
    /// Custom Methods
    func toggleEditingBarButton(_ button: UIBarButtonItem)
    func isNeedEditNotes(_ status: Bool)
    func deleteNoteActivityIndicatorStart()
    func deleteNoteActivityIndicatorStop()
}
