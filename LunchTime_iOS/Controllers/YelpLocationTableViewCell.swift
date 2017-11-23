//
//  YelpLocationTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/20/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI

class YelpLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var yelpBusinessImage: UIImageView!
    @IBOutlet weak var yelpBusinessName: UILabel!
    @IBOutlet weak var yelpBusinessAddress: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var yelpBusiness: YLPBusiness?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func commonInit(business: YLPBusiness) {
        let url = business.imageURL
        self.yelpBusinessImage.sd_setImage(with: url)
        yelpBusinessName.text = business.name
        yelpBusiness = business
        let location = business.location
        if location.address.count >= 1 {
            yelpBusinessAddress.text = "\(location.address[0]), \(location.city)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //unwind segue to create event
    }
    
    @IBAction func viewInYelpButtonPressed(_ sender: Any) {
        if let business = yelpBusiness {
            let yelpUrl = business.url
            if UIApplication.shared.canOpenURL(yelpUrl as URL) {
                UIApplication.shared.open(yelpUrl)
            }
        }
    }
    
}
