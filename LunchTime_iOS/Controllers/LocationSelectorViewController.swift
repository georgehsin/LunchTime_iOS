//
//  LocationSelectorViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/19/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI

struct tableViewCellData {
    let image: UIImage
    let name: String
    let address: String
}

class LocationSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var yelp = YelpSearchViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    var yelpBusinesses: [YLPBusiness]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let cell = Bundle.main.loadNibNamed("YelpLocationTableViewCell", owner: self, options: nil)
        let nib = UINib(nibName: "YelpLocationTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "yelpCell")
        DispatchQueue.global(qos: .userInteractive).async {
            self.yelp.queryYelp(term: "bar", location: "San Jose, CA") { (results) in
                self.yelpBusinesses = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let yelpBusinesses = yelpBusinesses {
            return yelpBusinesses.count
        }
        else {
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yelpCell", for: indexPath) as! YelpLocationTableViewCell
        if let business = yelpBusinesses?[indexPath.row] {
            let url = business.imageURL
            let data = try? Data(contentsOf: url!)
            cell.yelpBusinessImage.image = UIImage(data: data!)
            cell.yelpBusinessName.text = business.name
            let location = business.location
            cell.yelpBusinessAddress.text = "\(location.address[0]), \(location.city)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

}
