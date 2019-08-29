//
//  LoginViewController.swift
//  Route
//
//  Created by Надежда Морозова on 09/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    enum Constants {
        static let login = "admin"
        static let password = "123456"
    }
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.autocorrectionType = .no
        passwordView.isSecureTextEntry = true
        checkLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        loginView.text?.removeAll()
        passwordView.text?.removeAll()
        self.loginButton.isEnabled = false
    }
    
    @IBAction func login(_ sender: Any) {
        guard
            let login = loginView.text,
            let password = passwordView.text,
            login == Constants.login && password == Constants.password
        else {
                loginButton.isEnabled = true
        return
    }
    
        UserDefaults.standard.set(true, forKey: "isLogin")
        performSegue(withIdentifier: "toMain", sender: sender)
        print("Логин")
    }
    
    @IBAction func recovery(_ sender: Any) {
     performSegue(withIdentifier: "onRecover", sender: sender)
    }
//
//    @IBAction func logout(_ sender: Any) {
//        UserDefaults.standard.set(false, forKey: "isLogin")
//    }
    @IBAction func logout(_ segue: UIStoryboardSegue) {
        UserDefaults.standard.set(false, forKey: "isLogin")
    
    }

    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "onRegister", sender: sender)
    }
    
    func checkLogin() {
        Observable
        .combineLatest(loginView.rx.text,
                       passwordView.rx.text)
        
            .map { login, password in
                // Если введены логин и пароль больше 6 символов, будет возвращено “истина”
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            // Подписываемся на получение событий
            .bind { [weak loginButton] inputFilled in
                // Если событие означает успех, активируем кнопку, иначе деактивируем
                loginButton?.isEnabled = inputFilled
        }
    }
}
    
