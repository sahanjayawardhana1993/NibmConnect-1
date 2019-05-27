//
//  HomeViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/18/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import LocalAuthentication

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var floatButton: UIButton!
    var tableView:UITableView!
    var home = [Home]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.setGradientBackground(colorOne: primaryColor, colorTwo: secondaryColor)
        floatButton.creatingFloatingActionButton()
        //        floatButton.setImage(color: .red, for: .normal)
        //        floatButton.layer.cornerRadius = floatButton.frame.height / 2
        //        floatButton.layer.shadowOpacity = 0.25
        //        floatButton.layer.shadowRadius = 5
        //        floatButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        
        tableView = UITableView(frame: view.bounds,style: .plain)
        
        let cellNib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "homeCell")
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *){
            layoutGuide = view.safeAreaLayoutGuide
        }else{
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        observeHome()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.bringSubviewToFront(floatButton)
    }
    
    //    @IBAction func floatingButton(_ sender: Any) {
    //        self.performSegue(withIdentifier: "HomeWork", sender: self)
    //    }
    @IBAction func handleLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func myProfile(_ sender: Any) {
        //    self.performSegue(withIdentifier: "MyProfile", sender: nil)
        let context:LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access with your finger print", reply: {(wasCorrect, error) in
                if wasCorrect{
                    print("correct")
                    DispatchQueue.main.async { self.performSegue(withIdentifier: "MyProfile", sender: nil) }
                }else{
                    print("incorrect")
                }
            })
        }else{
            print("finger print doesn't support touch id")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentProfile"{
            
            let selectedIndex = sender as! Int
            
            let selectedStudent = self.home[selectedIndex]
            
            let destinationViewController = segue.destination as! StudentProfileViewController
            destinationViewController.home = selectedStudent
        }
    }
    
    func observeHome(){
        let ref = Database.database().reference().child("Home")
        ref.observe(.value, with:{snapshot in
            
            var tempHome = [Home]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let FirstName = dict["FirstName"] as? String,
                    let LastName = dict["LastName"] as? String,
                    let PhoneNumber = dict["PhoneNumber"] as? String,
                    let fbUrl = dict["fbUrl"] as? String,
                    let PhotoUrl = dict["PhotoUrl"] as? String,
                    let url = URL(string:PhotoUrl),
                    let City = dict["City"] as? String
                    //  let createdAt = dict["createdAt"] as? Double
                {
                    let home = Home(
                        FirstName:FirstName,
                        LastName:LastName,
                        PhoneNumber:PhoneNumber,
                        PhotoUrl:url,
                        City:City,
                        fbUrl:fbUrl//,
                        //   createdAt: createdAt
                    )
                    tempHome.append(home)
                    
                }
            }
            //        self.ref.child("Home").observeSingleEvent(of: .value, with: { (snapshot) in
            //            // Get user value
            //            let value = snapshot.value as? NSDictionary
            //            //let singersList = value!
            //            print(value!)
            //            var tempHome: [Home] = []
            //
            //            if snapshot.childrenCount > 0 {
            //                for singer in snapshot.children.allObjects as! [DataSnapshot] {
            //                    //getting values
            //                    let singerObject = singer.value as? [String: AnyObject]
            //                    let singer = Home(
            //                                        FirstName: singerObject!["FirstName"]  as! String,
            //                                        LastName: singerObject!["LastName"]  as! String,
            //                                        PhoneNumber: singerObject!["PhoneNumber"]  as! String,
            //                                        PhotoUrl: singerObject!["PhotoUrl"]  as! String,
            //                                        City: singerObject!["City"]  as! String
            //                    )
            //                    tempHome.append(singer)
            //                }
            //            }
            self.home = tempHome
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return home.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell",for: indexPath) as! HomeTableViewCell
        cell.set(home: home[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "StudentProfile", sender: indexPath.row)
    }
}
