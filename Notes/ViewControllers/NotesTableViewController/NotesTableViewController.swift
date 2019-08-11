//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    // MARK: - Properties
    let noteBook = FileNotebook.notebook
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    let dbOperationQueue = OperationQueue()
    let backendOperationQueue = OperationQueue()
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
    
        dbOperationQueue.maxConcurrentOperationCount = 1
        backendOperationQueue.maxConcurrentOperationCount = 1
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "noteCell")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveNotes),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadNotesData()
        activityIndicator.center = self.tableView.center
    }
}

