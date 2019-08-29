//
//  AlertClass.swift
//  Route
//
//  Created by Надежда Морозова on 12/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit

class AlertClass {
    
    func presentAlertWhenLoginFail(fromViewController controller: UIViewController) -> UIViewController {
        
        let alert = UIAlertController(title: "Login Error", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }
    
    func presentAlertWhenNewUser(fromViewController controller: UIViewController, action: @escaping () -> ()) -> UIViewController {
        
        let alert = UIAlertController(title: "Success Registration", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back To Login", style: .default, handler: { (_) in
            action()
        }))
        return alert
    }
    
    func presentAlertWhenNewPassword(fromViewController controller: UIViewController, action: @escaping () -> ()) -> UIViewController {
        
        let alert = UIAlertController(title: "New Password", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back To Login", style: .default, handler: { (_) in
            action()
        }))
        return alert
    }
}

