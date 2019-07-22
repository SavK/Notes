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
    var notebook = FileNotebook()
    var selectedIndex: Int?
    
    // MARK: - IB Actions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingMode(forButton: sender)
    }
    
    @IBAction func newNoteButtonTapped(_ sender: UIBarButtonItem) {
        selectedIndex = nil
        performSegue(withIdentifier: "showEditView", sender: nil)

        guard let editButton = navigationItem.leftBarButtonItem else { return }
        toggleEditingMode(forButton: editButton)
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? notebook.loadFromFile()
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "noteCell")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveNotes),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notebook.saveToFile()
    }
}

