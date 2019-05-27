//
//  UserService.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/24/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserService{
    static var currentUserProfile:User?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ user:User?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        
        userRef.observe(.value, with: { snapshot in
            var user:User?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let age = dict["age"] as? String,
                let telephone = dict["telephone"] as? String,
                let fbLink = dict["fbLink"] as? String,
                let profileImage = dict["profileImage"] as? String,
                let url = URL(string:profileImage) {
                
                user = User(uid: snapshot.key, username: username, profileImage: url, fbLink: fbLink,age: age,telephone: telephone )
            }
            
            completion(user)
        })
    }
}
