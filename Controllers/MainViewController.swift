//
//  MainViewController.swift
//  Route
//
//  Created by Надежда Морозова on 12/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBAction func showMap(_ sender: Any) {
        performSegue(withIdentifier: "toMap", sender: sender)
    }
    
    
    @IBAction func logout(_ sender: Any) {
     UserDefaults.standard.set(false, forKey: "isLogin")
        performSegue(withIdentifier: "toLogin", sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       

    }

}
