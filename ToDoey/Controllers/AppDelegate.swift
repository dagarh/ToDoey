//
//  AppDelegate.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import CoreData


// This class name is AppDelegate because it is the delegate of UIApplication.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // TodoListViewController class properties would be initialized even before this method call.
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    /* Here NSPersistentContainer object is creating sqlite database bydefault, by loading the persistent store. So here we are trying to grab the reference to the sqlite database. Since it is a lazy loading, it is going to be executed only once. We defined and called an anonymous function. */
    lazy var persistentContainer: NSPersistentContainer = {
        
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        /* Whole of the CoreData "DataModel"(all entities are defined in this) is going to be inside this persistent container. It means persistent container knows about the schema of all tables/entities used in our Core Data application. While loading persistent store, schema of entities is mandatory. This persistent container is going to load the persistent store, which is the repository where the actual data is stored. In many cases, the persistent store is a SQLite file(which is the case here), but it can also be a XML file, a binary file or a "in-memory" store for temporary data. So persistent container can load diff-2 types of persistent stores.
         Read more from this link : https://stackoverflow.com/questions/19615611/what-are-differences-between-managed-object-model-and-persistent-object-store
         */
        let container = NSPersistentContainer(name: "DataModel")
        /* This "name" has to match with the name of .xcdatamodeld file of core data so that persistent container gets to know about the schema of all entities in core data "DataModel". "DataModel.xcdatamodeld" contains all the entities & their properties And corresponding ".swift" files would be created automatically for us while creating entities & its properties. Remember that there is separate swift file for each entity and separate file for their properties. Entity class(.swift file) gets generated only once, untill/unless you delete entity or change entity name but entity's properties swift file(using extension on entity's class) gets generated many times.  */
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            /* Loading of this persistent store is synchronous with the main thread. You can make it asynchronous also. Read more about this from : https://stackoverflow.com/questions/45398230/does-the-completionhandler-of-loadpersistentstores-of-nspersistentcontainer-run */
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        /* Created the sqlite database above which is in non-volatile memory of iOS and we have a reference to that store/db in RAM. So we can get the viewContext and with the help of that context we can load any of the tables/entities in RAM. So all CRUD operations would happen in RAM and at the time of context.save(), all changes would be stored in DB, which is in non-volatile memory. */
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        
        /* With the help of viewContext :
         a) We can load any of our table/entity and its data in RAM so that we can do CRUD operations on it.
         b) And we can also get the temporary buffer area in RAM where CRUD operations happened and then when we do context.save(), to save all the changes, from temporary memory buffer, to the sqlite database. And sqlite database is in non-volatile memory of iOS. */
        let context = persistentContainer.viewContext
        
        // context area is same as the staging area of gitHub.
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

