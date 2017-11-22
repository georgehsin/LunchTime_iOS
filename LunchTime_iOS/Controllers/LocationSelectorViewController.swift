//
//  LocationSelectorViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/19/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI
import GooglePlaces

struct tableViewCellData {
    let image: UIImage
    let name: String
    let address: String
}

class LocationSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private var yelp = YelpSearchViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    @IBOutlet weak var foodSearchBar: UITextField!
    @IBOutlet weak var locationSearchBar: UITextField!
    var yelpBusinesses: [YLPBusiness]?
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.yelp.queryYelp(term: self.foodSearchBar.text!, location: self.locationSearchBar.text!) { (results) in
                self.yelpBusinesses = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let cell = Bundle.main.loadNibNamed("YelpLocationTableViewCell", owner: self, options: nil)
        let nib = UINib(nibName: "YelpLocationTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "yelpCell")
        DispatchQueue.global(qos: .userInteractive).async {
            self.yelp.queryYelp(term: "food", location: "San Jose, CA") { (results) in
                self.yelpBusinesses = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.locationSearchBar.delegate = self
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }
}

//MARK: Google Location Search auto-complete
extension LocationSelectorViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        locationSearchBar.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
