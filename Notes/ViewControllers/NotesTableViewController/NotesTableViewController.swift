//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreData
import Network

class NotesTableViewController: UITableViewController {
    
    @IBOutlet var leftBarButton: UIBarButtonItem!
    
    // MARK: - Properties
    let noteBook = FileNotebook.notebook
    let dbOperationQueue = OperationQueue()
    let backendOperationQueue = OperationQueue()
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    var selectedIndex: Int?
    var notes: [Note] = []
    /// Internet connection monitor
    let monitor = NWPathMonitor()
    let monitorNWConnectionQueue = DispatchQueue(label: "InternetConnectionMonitor")
    /// CoreData context
    var backgroundContext: NSManagedObjectContext!
    
    
    // MARK: - IB Actions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        toggleEditingBarButton(sender)
    }
    
    @IBAction func newNoteButtonTapped(_ sender: UIBarButtonItem) {
        selectedIndex = nil
        performSegue(withIdentifier: "showEditView", sender: nil)

        if tableView.isEditing {
        guard let editButton = navigationItem.leftBarButtonItem else { return }
        toggleEditingBarButton(editButton)
        }
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNetworkConnectionMonitor()
        
        dbOperationQueue.maxConcurrentOperationCount = 1
        backendOperationQueue.maxConcurrentOperationCount = 1
        
        tableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "noteCell")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveNotes),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        /// Customizing
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadNotesData()
    }
}
