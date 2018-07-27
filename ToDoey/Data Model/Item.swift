//
//  Item.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

class Item {
    
    var title: String
    var done: Bool
    
    init(title: String = "", done: Bool = false) {
        self.title = title
        self.done = done
    }
    
}
