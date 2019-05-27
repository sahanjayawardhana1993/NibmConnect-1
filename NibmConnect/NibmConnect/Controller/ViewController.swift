//
//  ViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/18/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    //let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 180/255, alpha: 1)
    //let secondaryColor = UIColor(red: 52/255, green: 148/255, blue: 230/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //    view.setGradientBackground(colorOne: UIColor.orange, colorTwo: UIColor.white)
    }
    override func viewDidAppear(_ animated: Bool) {
        //        if Auth.auth().currentUser != nil{
        //          //  print("current user is \(String(describing: Auth.auth().currentUser?.email))")
        //            self.performSegue(withIdentifier: "Home", sender: self)
        //        }else{
        //            self.performSegue(withIdentifier: "SignIn", sender: nil)
        //        }
    }
}

