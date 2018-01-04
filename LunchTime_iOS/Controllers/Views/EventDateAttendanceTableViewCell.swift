//
//  EventDateAttendanceTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 1/3/18.
//  Copyright © 2018 georgehsin. All rights reserved.
//

import UIKit

class EventDateAttendanceTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(date: Date, attending: Bool?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, hh:mm"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        setYesNoButtons(attending: attending)
    }
    
    func createUI() {
        yesButton.roundedButton(corner: [.topLeft, .bottomLeft], radius: 10, borderColor: Constants.Colors.appOrange)
        noButton.roundedButton(corner: [.topRight, .bottomRight], radius: 10, borderColor: Constants.Colors.appOrange)
    }
    
    func setYesNoButtons(attending: Bool? = nil) {
        if let attending = attending {
            if attending {
                yesButtonPressed(self)
            } else {
                noButtonPressed(self)
            }
        }
    }
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        yesButton.layer.backgroundColor = Constants.Colors.appOrange.cgColor
        noButton.layer.backgroundColor = UIColor.clear.cgColor
        yesButton.setTitleColor(UIColor.white, for: .normal)
        noButton.setTitleColor(Constants.Colors.appOrange, for: .normal)
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        noButton.layer.backgroundColor = Constants.Colors.appOrange.cgColor
        yesButton.layer.backgroundColor = UIColor.clear.cgColor
        noButton.setTitleColor(UIColor.white, for: .normal)
        yesButton.setTitleColor(Constants.Colors.appOrange, for: .normal)
    }
}
