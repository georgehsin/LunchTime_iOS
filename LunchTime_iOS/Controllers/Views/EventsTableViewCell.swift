//
//  EventsTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/18/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
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
    
    @IBAction func AdditionalEventInfoButtonPressed(_ sender: Any) {
        print("AdditionalEventInfoButtonPressed")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
}

extension UIButton {
    func roundedButton(corner: UIRectCorner, radius: CGFloat, borderColor: UIColor? = nil){
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: corner,
                                     cornerRadii:CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
        if let borderColor = borderColor {
            let borderLayer = CAShapeLayer()
            borderLayer.frame = self.bounds
            borderLayer.path  = maskPath.cgPath
            borderLayer.lineWidth = 2
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.fillColor   = UIColor.clear.cgColor
            self.layer.addSublayer(borderLayer)
        }
    }
}
