//
//  YelpLocationTableViewCell.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/20/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI

struct YelpCell {
    var business: YLPBusiness
    var image: UIImage
    var name: String
    var address: String
    
    init(business: YLPBusiness) {
        let url = business.imageURL
        self.business = business
        let data = try? Data(contentsOf: url!)
        image = UIImage(data: data!)!
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data!)!
//            }
//        }
//
        name = business.name
        address = business.location.address[0]
    }
}

class YelpLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var yelpBusinessImage: UIImageView!
    @IBOutlet weak var yelpBusinessName: UILabel!
    @IBOutlet weak var yelpBusinessAddress: UILabel!
    
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
        yelpBusinessAddress.text = "\(location.address[0]), \(location.city)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //unwind segue to create event
    }
    
    @IBAction func selectButtonPressed(_ sender: Any) {
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
