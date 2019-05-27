//
//  StudentProfileViewController.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/24/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit

class StudentProfileViewController: UIViewController {
    
    @IBOutlet weak var facebook: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    
    var home: Home?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: primaryColor, colorTwo: secondaryColor)
        
        studentImage.layer.cornerRadius = studentImage.bounds.height / 2
        studentImage.clipsToBounds = true
        self.firstName.text = home?.FirstName
        self.lastName.text = home?.LastName
        self.telephone.text = home?.PhoneNumber
        ImageService.getImage(withURL: home!.PhotoUrl){ image in
            self.studentImage.image = image
        }
        
    }
}
