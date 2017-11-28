//
//  FriendsSearchTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/27/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class FriendsSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func addFriendButtonPressed(_ sender: Any) {
        print("Sending a friend request to \(emailLabel.text!)")
    }
}
