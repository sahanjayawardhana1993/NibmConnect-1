//
//  HomeTableViewCell.swift
//  NibmConnect
//
//  Created by Bhanuka Isuru on 5/19/19.
//  Copyright © 2019 Bhanuka Isuru. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(home:Home){
        ImageService.getImage(withURL: home.PhotoUrl){image in
            self.profileImageView.image = image
        }
        usernameLabel.text = home.FirstName
        phoneLabel.text = home.PhoneNumber
        cityLabel.text = home.City
       // timeLabel.text = home.createdAt.calenderTimeSinceNow()
    }
}
