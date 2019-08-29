//
//  User.swift
//  Route
//
//  Created by Надежда Морозова on 09/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
    convenience init (login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
    }
}
