//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    
    // MARK: - Properties
    private(set) var result: SaveNotesBackendResult?
    private let semaphore = DispatchSemaphore(value: 0)
    var notes: [Note]
    
    init(notes: [Note]) {
        self.notes = notes
        super.init()
    }
    
    override func main() {
        let json = FileNotebook.convertNoteToJsonData(notes: notes)
        if UserSettings.shared.gitHubGistID.isEmpty {
            postGist(data: json)
        } else {
            patchGist(data: json)
        }
        semaphore.wait()
        finish()
    }
}

// MARK: - GitHub Gists Methods
extension SaveNotesBackendOperation {
    
    private func postGist(data: Data) {
        let description = "Save Notes"
        let isPublic = false
        let gistFileWithNotes = FileContent(content: String(data: data,
                                                            encoding: .utf8)!)
        
        let gistFiles = [UserSettings.shared.gitHubGistFileName: gistFileWithNotes]
        
        let gist = SendGistProperties(gistsDescription: description,
                                      gistsPublic: isPublic,
                                      files: gistFiles)
        
        guard let url = URL(string: apiGitHubURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("token \(UserSettings.shared.gitHubToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(gist)
            request.httpBody = data
        } catch {
            DDLogError("ERROR POST request: \(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                 DDLogError("ERROR POST request: \(error.localizedDescription)")
                self.result = .failure(.unreachable)
            } else {
                self.result = .success
            }
            self.semaphore.signal()
        }
        task.resume()
    }
    
    private func patchGist(data:Data) {
        let description = "Save Notes"
        let isPublic = false
        let gistFileWithNotes = FileContent(content: String(data: data,
                                                            encoding: .utf8)!)
        
        let gistFiles = [UserSettings.shared.gitHubGistFileName: gistFileWithNotes]
        
        let gist = SendGistProperties(gistsDescription: description,
                                      gistsPublic: isPublic,
                                      files: gistFiles)
        
        guard var url = URL(string: apiGitHubURL) else { return }
        url.appendPathComponent(UserSettings.shared.gitHubGistID)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("token \(UserSettings.shared.gitHubToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(gist)
            request.httpBody = data
        } catch {
            DDLogError("ERROR PATCH request: \(error.localizedDescription)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DDLogError("ERROR PATCH request: \(error.localizedDescription)")
                self.result = .failure(.unreachable)
            } else {
                self.result = .success
            }
            self.semaphore.signal()
        }
        task.resume()
    }
}
