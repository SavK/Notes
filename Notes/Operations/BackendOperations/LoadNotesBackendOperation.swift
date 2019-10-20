//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/31/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    
    // MARK: - Properties
    private(set) var result: LoadNotesBackendResult?
    var notes = [Note]()
    
    override init() {
        super.init()
        
        if UserSettings.shared.isNeedAuthorization || !UserSettings.shared.isLoginedInGitHub {
            cancel()
        }
    }
    
    override func main() {
        
        if isCancelled {  return }
        
        guard let url = URL(string: apiGitHubURL) else { return }
        var request = URLRequest(url: url)
        let token = UserSettings.shared.gitHubToken
        
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
        guard let `self` = self else { return }
            if let error = error {
                DDLogError("ERROR load from backend: \(error.localizedDescription)")
                self.fail()
                return
            }
            
            guard let data = data else {
                DDLogError("ERROR: download data with notes from gist failed!")
                self.fail()
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                
                let gitData = try decoder.decode([GitHubGist].self, from: data)
                self.findGistWithNotes(gists: gitData)
            } catch let decodeError {
                DDLogError("ERROR decode from backend: \(decodeError.localizedDescription)")
                self.fail()
            }
        }
        task.resume()
    }
}

// MARK: - Operation Results
extension LoadNotesBackendOperation {
    
    private func fail() {
        result = .failure(.unreachable)
        DDLogError("loading notes from backend FAILED")
        finish()
    }
    
    private func success() {
        result = .success(notes)
        DDLogDebug("loading notes from backend SUCCESS")
        finish()
    }
}

// MARK: - GitHub Gist Methods
extension LoadNotesBackendOperation {
    
    private func findGistWithNotes(gists: [GitHubGist]) {
        for gist in gists {
            if let index = gist.files.firstIndex(where: {
                $0.value.filename == UserSettings.shared.gitHubGistFileName
            }) {
                let gistWithNotesURL = gist.files[index].value.rawUrl
                UserSettings.shared.gitHubGistID = gist.id
                downloadNotesFromGist(from: gistWithNotesURL)
                return
            }
        }
        fail()
    }
    
    private func downloadNotesFromGist(from url: String) {
        guard let gistWithNotesURL = URL(string: url) else {
            fail()
            return
        }
        
        /// Stop download if internet connection is lost
        guard UserSettings.shared.isInternetConnectionOn else {
            fail()
            return
        }
        
        var request = URLRequest(url: gistWithNotesURL)
        request.setValue("token \(UserSettings.shared.gitHubToken)",
            forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
        guard let `self` = self else { return }
            if let error = error {
                DDLogError("ERROR download notes from gist: \(error.localizedDescription)")
                self.fail()
                return
            }
            
            guard let data = data else {
                DDLogError("ERROR: download data with notes from gist failed!")
                self.fail()
                return
            }
            
            self.notes = FileNotebook.convertNoteFromJson(data: data)
            self.success()
        }
        task.resume()
    }
}
