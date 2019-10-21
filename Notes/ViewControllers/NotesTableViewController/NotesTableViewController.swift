//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController, NotesTableViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet var leftBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    var presenter: NotesPresenterProtocol!
    let deleteNoteActivityIndicator = UIActivityIndicatorView(style: .gray)

    
    
    // MARK: - IB Actions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingBarButton(sender)
    }
    
    @IBAction func newNoteButtonTapped() {
        presenter.newNoteButtonAction()
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Customizing
        deleteNoteActivityIndicator.hidesWhenStopped = true
        view.addSubview(deleteNoteActivityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.loadNotesData()
    }
}
