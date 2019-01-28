//
//  AppDelegate.swift
//  PrayerList
//
//  Created by Devin  on 29/11/18.
//  Copyright © 2018 Devin Davies. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        UINavigationBar.appearance().tintColor = Theme.Color.PrimaryTint
        UITabBar.appearance().tintColor = Theme.Color.PrimaryTint
        UITabBar.appearance().unselectedItemTintColor = Theme.Color.TabBarInactive
        
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().backgroundColor = Theme.Color.LightGrey
        
        if !PLUserDefaults.hasSetUp {
            prepopulateCoreData()
            PLUserDefaults.hasSetUp = true
        }
        
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
    }
    
    func prepopulateCoreData(){
        let defaultCategories = [CategoryModel(name: "Thanks", order: 0), CategoryModel(name: "Family & Friends", order: 1), CategoryModel(name: "EACO", order: 2), CategoryModel(name: "Ecclesia", order: 3), CategoryModel(name: "Temporary", order: 4)]
        
        let defaultPrayers = [PrayerModel(name: "Morning", order: 0), PrayerModel(name: "Midday", order: 1), PrayerModel(name: "Evening", order: 2)]
        
        for prayer in defaultPrayers {
            PrayerInterface.savePrayer(prayer: prayer, inContext: CoreDataManager.mainContext)
        }
        
        for category in defaultCategories {
            CategoryInterface.saveCategory(category: category, inContext: CoreDataManager.mainContext)
        }
        
    }

}

