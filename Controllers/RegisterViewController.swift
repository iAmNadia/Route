//
//  RegisterViewController.swift
//  Route
//
//  Created by Надежда Морозова on 09/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var loginRegisterText: UITextField!
    @IBOutlet weak var passwordRegisterText: UITextField!
  
     var canCreateNewUser = true
    
    @IBAction func Register(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createUser(_ sender: Any) {
        guard let loginText = loginRegisterText.text else {return}
        guard let passwordText = passwordRegisterText.text else {return}
        
        if !loginText.isEmpty && !passwordText.isEmpty {
            let allUsert = UserClass().loadUserData()
            for i in allUsert {
                if i.login == loginRegisterText.text {
                   
                    canCreateNewUser = false
                    self.present(AlertClass().presentAlertWhenNewPassword(fromViewController: self, action: {self.dismiss(animated: true, completion: nil)}), animated: true, completion: nil)
                }
            }
            
            UserClass().saveUserData(User(login: loginText, password: passwordText))
            
            if canCreateNewUser {
                self.present(AlertClass().presentAlertWhenNewUser(fromViewController: self, action: {self.dismiss(animated: true, completion: nil)}), animated: true, completion: nil)
                canCreateNewUser = true
            }
        }
    }
}
