//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import RealmSwift

// This class name is AppDelegate because it is the delegate of UIApplication.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // TodoListViewController class properties would be initialized even before this method call.
        
        // This is the location for realm database file.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            // it is creating the realm store on non-volatile memory.
            _ = try Realm()
        } catch{
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }
    
}

