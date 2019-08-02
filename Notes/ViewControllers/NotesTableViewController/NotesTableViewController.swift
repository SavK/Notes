//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CocoaLumberjack

class NotesTableViewController: UITableViewController {
    
    // MARK: - Properties
    let noteBook = FileNotebook.notebook
    var selectedIndex: Int?
    var notes: [Note] = []
    
    // MARK: - IB Actions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingMode(forButton: sender)
    }
    
    @IBAction func newNoteButtonTapped(_ sender: UIBarButtonItem) {
        selectedIndex = nil
        performSegue(withIdentifier: "showEditView", sender: nil)

        if tableView.isEditing {
        guard let editButton = navigationItem.leftBarButtonItem else { return }
        toggleEditingMode(forButton: editButton)
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "noteCell")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveNotes),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    /// Load notes when viewWillAppear
    override func viewWillAppear(_ animated: Bool) {

        let loadNotes = LoadNotesOperation(notebook: FileNotebook.notebook,
                                           backendQueue: OperationQueue(),
                                           dbQueue: OperationQueue())
        
        loadNotes.completionBlock = {
            let loadedNotes = loadNotes.result ?? []
            DDLogDebug(" \(loadedNotes.count) notes was uploaded")
            self.notes = loadedNotes

            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                super.viewWillAppear(animated)
            }
        }
        OperationQueue().addOperation(loadNotes)
    }
}

