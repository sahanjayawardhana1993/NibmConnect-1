//
//  MyProfileViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/24/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var facebook: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var born: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var aboutme: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myImage.layer.masksToBounds = true
        myImage.layer.borderWidth = 2
        myImage.layer.borderColor = UIColor.white.cgColor
        myImage.layer.cornerRadius = myImage.bounds.width / 2
        
        observeProfile()
        // Do any additional setup after loading the view.
    }
    
    func observeProfile(){
        let currentUser = Auth.auth().currentUser
        let userid: String = currentUser!.uid
        let email: String = (currentUser?.email)!
        // print(userid)
       //  guard let userProfile = UserService.currentUserProfile else { return }
       //         let uid = UserService.currentUserProfile?.uid
         //        print(uid)
        let ref = Database.database().reference().child("users/profile/\(userid)")
       // print(userid)
        ref.observe(.value, with: {snapshot in
            let value = snapshot.value as? NSDictionary
          //  print(value)
            let username = value?["username"] as? String ?? ""
            let PhotoUrl = value?["photoURL"] as? String
            let fbLink = value?["fbLink"] as? String
            let age = value?["age"] as? String
            let telephone = value?["telephone"] as? String
            let url: URL
            if PhotoUrl != nil{
                url = URL(string:PhotoUrl!)!
            }else{
                url = URL(string:"https://firebasestorage.googleapis.com/v0/b/nibmconnect-33434.appspot.com/o/user%2FnHA7gjyegnfDGwv7Cyx91JkfVwv1?alt=media&token=6debf274-e0fc-45c9-b3bf-bd29bd890771")!
            }
            
            ImageService.getImage(withURL: url){image in
                self.myImage.image = image
            }
            self.name.text = username
            self.born.text = age
            self.facebook.text = fbLink
            self.telephone.text = telephone
            self.email.text = email
        })
    }
}
