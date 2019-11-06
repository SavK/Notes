//
//  NotesPresenter+CustomMethods.swift
//  Notes
//
//  Created by Savonevich Constantine on 10/21/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

// MARK: - Custom Methods
extension NotesPresenter {
    
    func loadNetworkConnectionMonitor() {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            UserSettings.shared.isInternetConnectionOn =
                pathUpdateHandler.status == .satisfied ? true : false
        }
        monitor.start(queue: monitorNWConnectionQueue)
    }
}
