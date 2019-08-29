//
//  RecoveryPasswordViewController.swift
//  Route
//
//  Created by Надежда Морозова on 09/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import Foundation

import UIKit

final class RecoveryPasswordViewController: UIViewController {
    
    @IBOutlet weak var loginView: UITextField!
    
    @IBAction func recovery(_ sender: Any) {
        guard
            let login = loginView.text,
            login == LoginViewController.Constants.login else {
                
                return
        }
        
        showPassword()
    }
    
    private func showPassword() {
        let alert = UIAlertController(title: "Пароль", message: "123456", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
