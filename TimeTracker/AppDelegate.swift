//
//  AppDelegate.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 18.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        FIRService.sharedInstance.configure()
        return true
    }
}

