//
//  AppDelegate.swift
//  Notes
//
//  Created by Savonevich Constantine on 7/1/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    public let fileLogger: DDFileLogger = DDFileLogger()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLogger()
        return true
    }
    
    /// We’ll be storing the last 7 days worth of logs and we’ll create a new file each day.
    private func setupLogger() {
        DDLog.add(DDTTYLogger.sharedInstance)
    
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .info)
    }
}

