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
    public func add(note: Note) {
        guard let replaceNoteIndex = notes.firstIndex(where: { $0.uid == note.uid }) else {
            notes.append(note)
            return
        }
        notes.remove(at: replaceNoteIndex)
        notes.insert(note, at: 0)
    }
    
    /// Remove note with received UID
    public func remove(noteWith uid: String) {
        guard let removeNoteIndex = notes.firstIndex(where: { $0.uid == uid }) else {
            DDLogInfo("Note with UID=\(uid) wasn't find in DB.")
            return
        }
        DDLogInfo("Note was removed from DB. UID=\(uid)")
        notes.remove(at: removeNoteIndex)
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
    public func saveNotesToFile() {
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
    public func loadNotesFromFile() throws {
        notes.removeAll()
        do {
            if let data = try? Data(contentsOf: getCacheFileDirectory()),
                let jsonData = try JSONSerialization.jsonObject(with: data,
                                                                options: []) as? [[String: Any]] {
                
                jsonData.forEach {
                    guard let note = Note.parse(json: $0) else { return }
                    self.add(note: note)
                }
            } else {
                DDLogError("Can't load notes from file.")
            }
        } catch {
            DDLogError("ERROR load from file: \(error.localizedDescription)")
        }
    }
    
    static func convertNoteFromJson(data: Data) -> [Note] {
        var arrayOfNotes: [Note] = []
        do {
            guard let notes = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                else { return arrayOfNotes }
            
            arrayOfNotes = notes.compactMap { Note.parse(json: $0) }
        } catch {
            DDLogError("ERROR convert data from JSON: \(error.localizedDescription)")
        }
        return arrayOfNotes
    }
    
    static func convertNoteToJsonData(notes: [Note]) -> Data {
        do {
            let notes = notes.compactMap { $0.json }
            let data = try JSONSerialization.data(withJSONObject: notes, options: [])
            return data
        } catch {
            DDLogError("ERROR convert JSON from note: \(error.localizedDescription)")
            return Data()
        }
    }
    
    /// Convert notes into JSON Object
    private func getJSONObject() -> [[String:Any]] {
        var jsonArray = [[String: Any]]()
        notes.forEach { jsonArray.append($0.json) }
        return jsonArray
    }
}

