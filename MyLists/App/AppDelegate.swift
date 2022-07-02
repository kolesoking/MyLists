//
//  AppDelegate.swift
//  MyLists
//
//  Created by катя on 01.07.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: ClientsListViewController())
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }

}

