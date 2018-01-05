//
//  ProfileTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 1/4/18.
//  Copyright © 2018 georgehsin. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var valueForAttributeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(attribute: String, value: String) {
        attributeLabel.text = attribute
        valueForAttributeLabel.text = value
    }
    
}
