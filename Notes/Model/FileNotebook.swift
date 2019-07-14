//
//  FileNotebook.swift
//  Notes
//
//  Created by Savonevich Constantine on 6/29/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {

    
    // MARK: - Stored Properties
    private(set) var notes: [Note]
    let archiveURL: URL
    let documentDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                     in: .userDomainMask).first!
    
    /// Add new note with UID checking
    public func add(_ note: Note) {
        for element in notes {
            if note.uid == element.uid {
                DDLogWarn("Can't save note, because we alredy have note with UID: \(element.uid)")
                return
            }
        }
        DDLogInfo("Note was added. UID=\(note.uid)")
        notes.append(note)
    }
    
    /// Remove note with received UID
    public func remove(with uid: String) {
        for (index, element) in notes.enumerated() {
            if uid == element.uid {
                DDLogInfo("Note was removed. UID=\(uid)")
                notes.remove(at: index)
            }
        }
    }
    
    init(notes: [Note]) {
        self.notes = notes
        archiveURL = documentDirectory.appendingPathComponent("FileNotebook").appendingPathExtension("json")
    }
    
    /// Save notes as JSON Data into file
    public func saveToFile() {
        do {
            let data = try JSONSerialization.data(withJSONObject: getJSONObject(), options: [])
            try data.write(to: archiveURL)
        } catch {
            DDLogError("ERROR: \(error.localizedDescription)")
        }
    }
    /// Load JSON Data from file and update notes
    public func loadFromFile() {
        do {
            let data = try Data(contentsOf: archiveURL, options: .mappedIfSafe)
            let jsonDicts = try JSONSerialization.jsonObject(with: data,
                                                             options: []) as! [[String: Any]]
            
            notes.removeAll()
            jsonDicts.forEach { notes.append(Note.parse(json: $0)!) }
        } catch {
            DDLogError("ERROR: \(error.localizedDescription)")
        }
    }
    
    /// Convert notes into JSON Object
    private func getJSONObject() -> [[String:Any]] {
        var jsonArray = [[String: Any]]()

        for note in notes {
            jsonArray.append(note.json)
        }
        return jsonArray
    }
}

