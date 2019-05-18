//
//  ViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/18/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         view.setGradientBackground(colorOne: UIColor.orange, colorTwo: UIColor.white)
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "Home", sender: self)
        }else{
            self.performSegue(withIdentifier: "SignIn", sender: nil)
        }
    }
}

