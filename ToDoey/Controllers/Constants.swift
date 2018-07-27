//
//  Constants.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import Foundation

class Constants {
    
    /* There are two types of properties. One is stored property and another is computed property. Computed property is going to have it's accessors which you have to specify at least one. Computed property can only be overriden in a subclass, hence class keyword can't be used with stored property. */
    
    // Read the blog for properties.
    
    // It is a computed property and hence can not be let i.e immutable. It has to be mutable.
    static var itemArrayKey: String {
        get {
            return "todoListArray"
        }
    }
    
    
}
