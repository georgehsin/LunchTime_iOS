//
//  FriendAttendanceTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/29/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class FriendAttendanceTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var attendanceStatusLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(email: String, attending status: Bool? = nil ) {
        emailLabel.text = email
        if status == nil {
            createUI(attending: nil)
        }
        else if status! {
            attendanceStatusLabel.setTitle("Yes", for: .normal)
            createUI(attending: true)
        } else {
            attendanceStatusLabel.setTitle("No", for: .normal)
            createUI(attending: false)
        }
    }
    
    func createUI(attending: Bool? = nil) {
        if attending == nil {
            attendanceStatusLabel.setTitle("Pending", for: .normal)
            attendanceStatusLabel.backgroundColor = UIColor.clear
            attendanceStatusLabel.setTitleColor(Constants.Colors.appOrange, for: .normal)
        }
        else if attending! {
            attendanceStatusLabel.backgroundColor = Constants.Colors.appOrange
            attendanceStatusLabel.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            attendanceStatusLabel.backgroundColor = UIColor.clear
            attendanceStatusLabel.setTitleColor(Constants.Colors.appOrange, for: .normal)
        }
        attendanceStatusLabel.layer.cornerRadius = 10
        attendanceStatusLabel.layer.borderColor = Constants.Colors.appOrange.cgColor
        attendanceStatusLabel.layer.borderWidth = 2

    }
}
