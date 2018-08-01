//
//  Category.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 01/08/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation
import RealmSwift


/* By inheriting from Object, "Category" objects are persistable in realm store. "Object" class is used to define Realm model objects. */
class Category : Object {
    
    @objc dynamic var name : String = ""
    
    // this is how we define forward relationship in realm using List class of Realm framework.
    let items : List<Item> = List<Item>()
}
