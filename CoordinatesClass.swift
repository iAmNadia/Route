//
//  CoordinatesClass.swift
//  Route
//
//  Created by Надежда Морозова on 08/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import Foundation
import RealmSwift

final class CoordinatesClass {
    
    func saveData(_ data: Coordinates) {
        
        do {
            let realm = try? Realm()
            realm?.beginWrite()
            realm?.add(data)
            try realm?.commitWrite()
        }
        catch {
            print(error)
        }
    }
    
    func loadData() -> [Coordinates] {
        var returnData = [Coordinates]()
        do {
            
            let realm = try? Realm()
            if let coordinates = realm?.objects(Coordinates.self) {
                returnData = Array(coordinates)
            }
            return returnData
            
        }
        catch {
            print(error)
        }
    }
    
    func deleteData() {
        do {
            let realm = try? Realm()
            realm?.beginWrite()
            realm?.deleteAll()
            try realm?.commitWrite()
            
        }
        catch {
            print(error)
        }
    }
}
