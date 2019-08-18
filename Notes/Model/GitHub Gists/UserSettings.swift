//
//  UserSettings.swift
//  Notes
//
//  Created by Savonevich Constantine on 8/10/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

class UserSettings {
    
    // MARK: - Properties
    static let shared: UserSettings = UserSettings()
    
    let gitHubGistFileName = "ios-course-notes-db"
    
    var gitHubToken: String = ""
    var gitHubGistID: String = ""
    var isLoginedInGitHub: Bool {
        return !gitHubToken.isEmpty
    }
    
    var isInternetConnectionOn = false
    /// Private init
    private init() {}
}
