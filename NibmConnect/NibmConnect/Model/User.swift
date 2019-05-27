//
//  User.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/24/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import Foundation

class User{
    var uid: String
    var profileImage: URL
    var username: String
    // var description: String
    var fbLink: String
    var age: String
    var telephone: String
    
    init(uid:String,
         username:String,
         profileImage:URL,
         fbLink:String,
         age:String,
         telephone:String
        ) {
        self.uid = uid
        self.profileImage = profileImage
        self.username = username
        self.fbLink = fbLink
        self.age = age
        self.telephone = telephone
    }
}
