//
//  SelfiViewController.swift
//  Route
//
//  Created by Надежда Морозова on 27/08/2019.
//  Copyright © 2019 Надежда Морозова. All rights reserved.
//

import UIKit

class SelfiViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
}
