//
//  ItemManager.swift
//  Reminder2
//
//  Created by Le Trung on 5/9/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//

import Foundation
import RealmSwift

class ItemManager {
    private init() {}
    
    static let shared = ItemManager()
    
    var realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        }
        catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String:Any?]) {
        do {
            try realm.write {
                for (key,value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        }
        catch {
            post(error)
        }
    }
    
    func delete<T: Object> (_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        }
        catch {
            post(error)
        }
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObserving(in vc: UIViewController){
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}
