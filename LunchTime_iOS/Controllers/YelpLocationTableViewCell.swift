//
//  YelpLocationTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/20/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class YelpLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var yelpBusinessImage: UIImageView!
    @IBOutlet weak var yelpBusinessName: UILabel!
    @IBOutlet weak var yelpBusinessAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectButtonPressed(_ sender: Any) {
    }
    
    @IBAction func viewInYelpButtonPressed(_ sender: Any) {
    }
}
