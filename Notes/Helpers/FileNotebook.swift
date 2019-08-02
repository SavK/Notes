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
    let documentDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                     in: .userDomainMask).first!
    
    static let notebook = FileNotebook()
    
    // MARK: - Initializators
    init() {
        self.notes = []
    }
    
    /// Add new note with UID checking
    public func add(_ note: Note) {
        for (index, element) in notes.enumerated() {
            if element.uid == note.uid {
                notes.remove(at: index)
                notes.insert(note, at: 0)
                return
            }
        }
        notes.append(note)
    }
    
    /// Remove note with received UID
    public func remove(with uid: String) {
        for (index, element) in notes.enumerated() {
            if uid == element.uid {
                DDLogInfo("Note was removed from DB. UID=\(uid)")
                notes.remove(at: index)
            }
        }
    }
    
    func getCacheFileDirectory() -> URL {
        let directoryURL = documentDirectory.appendingPathComponent("NotebookCache")
        var DirectoryExists: ObjCBool = false
        if !FileManager.default.fileExists(atPath: directoryURL.path,
                                           isDirectory: &DirectoryExists), !DirectoryExists.boolValue {
            
            try? FileManager.default.createDirectory(at: directoryURL,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        return directoryURL.appendingPathComponent("Notes")
    }
    
    /// Save notes as JSON Data into file
    public func saveToFile() {
        let jsonArray = notes.map { $0.json }
        if let data = try? JSONSerialization.data(withJSONObject: jsonArray, options: []) {
            if FileManager.default.createFile(atPath: getCacheFileDirectory().path, contents: data,
                                              attributes: nil) {
                DDLogInfo("Notes successfuly saved to DB")
            } else {
                DDLogError("ERROR: Notes didn't saved")
            }
        } else {
            DDLogError("ERROR: Data can't serialized")
        }
    }
    
    /// Load JSON Data from file and update notes
    public func loadFromFile() throws {
        notes.removeAll()
        do {
            if let data = try? Data(contentsOf: getCacheFileDirectory()),
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
    
    /// Convert notes into JSON Object
    private func getJSONObject() -> [[String:Any]] {
        var jsonArray = [[String: Any]]()
        
        for note in notes {
            jsonArray.append(note.json)
        }
        return jsonArray
    }
}

