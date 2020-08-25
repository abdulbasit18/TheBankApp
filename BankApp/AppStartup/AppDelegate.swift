//
//  AppDelegate.swift
//  Alzura-CodeTask
//
//  Created by Abdul Basit on 30/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit
import CoreData
import Swinject
import IQKeyboardManagerSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    
    static let container = Container()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Setup Keyboard Manager
        IQKeyboardManager.shared.enable = true
        
        //Register Dependencies
        AppDelegate.container.registerDependencies()
        
        //Start App
        self.appCoordinator = AppDelegate.container.resolve(AppCoordinator.self)!
        self.appCoordinator.start()
        return true
    }
    
}
