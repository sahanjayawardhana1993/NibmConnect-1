//
//  Home.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/20/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import Foundation

class Home{
    
    var FirstName:String
    var LastName:String
    var PhoneNumber:String
    var PhotoUrl: URL
    var City: String
    var fbUrl: String
    //  var createdAt:Date
    
    init(FirstName:String,LastName:String,PhoneNumber:String,PhotoUrl:URL,City:String,fbUrl: String//,
        //  createdAt: Double
        ) {
        self.FirstName = FirstName
        self.LastName = LastName
        self.PhoneNumber = PhoneNumber
        self.PhotoUrl = PhotoUrl
        self.City = City
        self.fbUrl = fbUrl
        // self.createdAt = Date(timeIntervalSince1970: createdAt / 1000)
    }
}
