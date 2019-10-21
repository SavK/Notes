//
//  AppDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/1/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public let fileLogger: DDFileLogger = DDFileLogger()
    
    var window: UIWindow?
    var container: NSPersistentContainer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLogger()
        
        createContainer { container in
            self.container = container
            
            if let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
                let notesTableViewController = navigationController.topViewController as? NotesTableViewController {
                
                notesTableViewController.presenter = NotesPresenter(viewController: notesTableViewController)
                notesTableViewController.presenter.backgroundContext = container.newBackgroundContext()
//                notesTableViewController.backgroundContext = container.newBackgroundContext()
            }
        }
        
        return true
    }
    
    /// Create Persistent container
    private func createContainer(completion: @escaping (NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "Notebook")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                DDLogError("\(error!.localizedDescription)")
                fatalError("Failed to load store")
            }
            completion(container)
        }
    }
    
    /// We’ll be storing the last 7 days worth of logs and we’ll create a new file each day.
    private func setupLogger() {
        DDLog.add(DDTTYLogger.sharedInstance)
        
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .info)
    }
}

