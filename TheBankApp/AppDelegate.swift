//
//  AppDelegate.swift
//  TheBankApp
//
//  Created by Abdul Basit on 09/03/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var appCoordinator: MainCoordinator?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window = window {
            let service = BasicNetworkServiceImpl()
            appCoordinator = MainCoordinator(window, service: service)
            appCoordinator?.start()
        }
        return true
    }
    
}
