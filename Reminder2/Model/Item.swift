//
//  Item.swift
//  Reminder2
//
//  Created by Le Trung on 5/3/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//


import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var note: String = ""
    @objc dynamic var dateCreated : Date?
    
    convenience init(title: String, note: String) {
        self.init()
        self.title = title
        self.note = note
        self.dateCreated = Date()
        self.done = false
        }
        
    
}

