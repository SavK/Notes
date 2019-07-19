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
    
    init(images: [Note]) {
        self.notes = notes
    }
    
    // MARK: - Stored Properties
    private(set) var notes: [Note]
    let documentDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                     in: .userDomainMask).first
    
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
    }
    
    /// Save notes as JSON Data into file
    public func saveToFile() {
        if let documentDirectory = documentDirectory {
            do {
                let jsonArray = notes.map { $0.json }
                let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
                let pathSave = documentDirectory.appendingPathComponent("notes.json")
                FileManager.default.createFile(atPath: pathSave.path, contents: data, attributes: nil)
            } catch let error {
                DDLogError("ERROR: \(error.localizedDescription)")
            }
        }
    }
    /// Load JSON Data from file and update notes
    public func loadFromFile() {
        notes.removeAll()
        if let documentDirectory = documentDirectory {
            do {
                let pathFile = documentDirectory.appendingPathComponent("notes.json")
                if let data = FileManager.default.contents(atPath: pathFile.path),
                    let jsonData = try JSONSerialization.jsonObject(with: data,
                                                                    options: []) as? [[String: Any]] {
            
                    for noteJson in jsonData {
                        guard let note = Note.parse(json: noteJson) else { return }
                        self.add(note)
                    }
                } else {
                    DDLogError("Can't load notes from file.")
                }
            } catch {
                DDLogError("ERROR: \(error.localizedDescription)")
            }
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

