//
//  Item.swift
//  ToDoey
//
//  Created by Himanshu Dagar on 27/07/18.
//  Copyright © 2018 Himanshu Dagar. All rights reserved.
//

import UIKit

/* This class must conform to the Encodable protocol. Then only "Item" type would be able to encode itself into a plist or JSON format using NSCoder. Always remember that a class can conform to Encodable, only if all of its properties are of standard datatypes, not custom datatypes. So class would not be able to conform to Encodable protocol if it is having at least one custom datatype. */

/* This class must conform to the Decodable protocol. Then only "Item" type could be decoded from plist file and it also ensures that the properties of "Item" type is of the standard datatype only, not any custom datatype. */

// Codable means it conforms to both Encodable and Decodable both.
class Item: Codable {
    
    var title: String
    var done: Bool
    
    init(title: String = "", done: Bool = false) {
        self.title = title
        self.done = done
    }
    
}
