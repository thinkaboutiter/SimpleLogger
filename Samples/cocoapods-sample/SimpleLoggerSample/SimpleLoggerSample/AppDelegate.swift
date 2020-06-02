//
//  AppDelegate.swift
//  SimpleLoggerSample
//
//  Created by Boyan Yankov on W38 20/Sep/2017 Wed.
//  Copyright © 2017 Boyan Yankov. All rights reserved.
//

import UIKit
import SimpleLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.setupConfigurations()
        
        // exercising
        self.exerciseSimpleLogger()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - Configurations
extension AppDelegate {
    
    fileprivate func setupConfigurations() {
        self.configure_simpleLogger()
    }
    
    private func configure_simpleLogger() {
        Logger.setVerbosityLevel(Logger.Verbosity.all.rawValue)
    }
}

// MARK: - Exercise Simple logger
extension AppDelegate {
    
    fileprivate func exerciseSimpleLogger() {
        self.log_message()
        self.log_object()
        self.log_nil()
    }
    
    private func log_message() {
        // info
        Logger.general.message("Logging `genereal` message")
        Logger.debug.message("Logging `debug` message")
        
        // status
        Logger.success.message("Logging `success` message")
        Logger.warning.message("Logging `warning` message")
        Logger.error.message("Logging `error` message")
        Logger.fatal.message("Logging `fatal` message")
        
        // data
        Logger.network.message("Logging `network` message")
        Logger.cache.message("Logging `cache` message")
    }
    
    private func log_object() {
        // array
        let sampleArray: [Int] = [
            0,
            1,
            2,
            3
        ]
        Logger.debug.message("Array:").object(sampleArray)
        
        // dictionary
        let sampleDictionary: [String: String] = [
            "key_0": "value_0",
            "key_1": "value_1",
            "key_2": "value_2",
            "key_3": "value_3"
        ]
        Logger.debug.message("Dictionary:").object(sampleDictionary)
    }
    
    private func log_nil() {
        Logger.debug.message("Logging nil:").object(nil)
    }
}
