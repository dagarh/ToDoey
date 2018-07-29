//
//  Item.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 29/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit
import CoreData

/* "Item" is subclassing "NSManagedObject" and hence "Item" would be managed by the core data (CoreData is used to manage model layer objects) and also schema of this "Item" entity will be tracked by persistent container. After inheriting from "NSManagedObject", "Item" is CoreData - datamodel class. */

/* Main thing is this : All those classes which want to be part of CoreData model, have to inherit from NSManagedObject so that NSManagedObject class would know about all those classes whose schema need to be delivered to persistent container. */
extension Item {
    
    // Since it is extension, so designated initializer can not be here.
    convenience init(title: String, done: Bool) {
        self.init()
        self.title = title
        self.done = done
    }
}
