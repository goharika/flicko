//
//  AppDelegate.swift
//  Flicko
//
//  Created by Gohar on 09/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var firstLaunchFlag = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // navigation appearance
        setNavigation()
        
        // remember first launch in order not download data every time
        firstLaunchFlag = UserDefaults.isFirstLaunch()
        
        // Data location
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()

        if firstLaunchFlag {
            downLoadImages()
        }
        
        // Override point for customization after application launch.
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
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataStack.sharedInstance.saveContext()
    }
    
    // MARK: Navigation
    
    func setNavigation() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.flGreen
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }

  
    func downLoadImages() {
        let service = APIService()
        service.getDataWith { (result) in
        switch result {
        case .Success(let data):
            DBManager.shared.saveInCoreDataWith(array: data)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil, userInfo: ["completed": true])
        case .Error(let message):
                DispatchQueue.main.async {
                    self.window?.rootViewController?.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }



}

