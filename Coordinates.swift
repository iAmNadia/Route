//
//  Coordinates.swift
//  Route
//
//  Created by Надежда Морозова on 08/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import Foundation
import RealmSwift

class Coordinates: Object {
    
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
