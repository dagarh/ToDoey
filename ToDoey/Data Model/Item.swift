//
//  Item.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 01/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation
import RealmSwift

/* By inheriting from Object, "Item" objects are persistable in realm store. "Object" class is used to define Realm model objects. */
class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // This is how we define inverse relationship.
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")

    convenience init(title : String = "", done : Bool = false) {
        self.init()
        self.title = title
        self.done = done
    }
    
}
