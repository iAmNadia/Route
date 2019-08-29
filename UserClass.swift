//
//  UserClass.swift
//  Route
//
//  Created by Надежда Морозова on 09/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import Foundation
import RealmSwift

final class UserClass {
    
    func saveUserData( _ data: User)  {
        
        do {
            let realm = try? Realm()
            realm?.beginWrite()
            realm?.add(data, update: true)
            try? realm?.commitWrite()
        }
            
        catch {
            fatalError("Realm error")
        }
    }
    
    func loadUserData() -> [User] {
        
        var returnData = [User]()
        
        do {
            let realm = try? Realm()
            if let users = realm?.objects(User.self) {
                returnData = Array(users)
            }
            return returnData
            
        }
        catch {
            fatalError("Realm error")
        }
    }
    
    func deleteUserDataForKey(_ key: String) {
        
        do {
            let realm = try? Realm()
            realm?.beginWrite()
            guard let object = realm?.object(ofType: User.self, forPrimaryKey: key) else {return}
            realm?.delete(object)
            try? realm?.commitWrite()
        }
    }
    
}
