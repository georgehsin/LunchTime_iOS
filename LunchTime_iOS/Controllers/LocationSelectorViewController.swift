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

class LocationSelectorViewController: UIViewController, UITextFieldDelegate {
    
    private var yelp = YelpSearchViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var foodSearchBar: UITextField!
    @IBOutlet weak var locationSearchBar: UITextField!
    let noLocationLabel = UILabel()
    var yelpBusinesses: [YLPBusiness]?
    var selectedLocation: YLPBusiness?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "YelpLocationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "yelpCell")
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        locationSearchBar.delegate = self
        createUI()
        if AppDelegate.currentLocation != nil {
            dispatchYelpQuery(term: "food", location: "", coordinate: AppDelegate.currentLocation)
        } else {
            createUpdateLocationLabel()
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func dispatchYelpQuery(term: String, location: String, coordinate: YLPCoordinate? = nil) {
        self.startActivityIndicator(indicator: self.activityIndicator)
        DispatchQueue.global(qos: .userInteractive).async {
            self.yelp.queryYelp(term: term, location: location, coordinate: coordinate) { (results) in
                self.yelpBusinesses = results
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if foodSearchBar.text! != "" && locationSearchBar.text! != "" {
            noLocationLabel.isHidden = true
            dispatchYelpQuery(term: foodSearchBar.text!, location: locationSearchBar.text!)
        }
        else {
            let message = "Food and Location needed"
            let alertController = ViewController.createAlert(title: "Invalid", message: message)
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
    func createUI() {
        activityIndicator.backgroundColor = Constants.Colors.backgroundGray
        activityIndicator.layer.cornerRadius = 10
    }
    
    func createUpdateLocationLabel() {
        activityIndicator.isHidden = true
        noLocationLabel.frame = CGRect(x: 20, y: self.view.frame.height/2 - 40, width: self.view.frame.width - 40, height: 40)
        noLocationLabel.text = "Enter food and location to search for results or enable location services"
        noLocationLabel.textAlignment = .center
        noLocationLabel.lineBreakMode = .byWordWrapping
        noLocationLabel.numberOfLines = 2
        noLocationLabel.sizeToFit()
        noLocationLabel.preferredMaxLayoutWidth = 300
        self.view.addSubview(noLocationLabel)
    }
    
}

//MARK:Delegate and DataSource Methods
extension LocationSelectorViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            cell.commonInit(business: business)
            cell.selectButton.tag = indexPath.row
            cell.selectButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
        }
        return cell
    }
    
    @objc func selectButtonPressed(sender: UIButton) {
        selectedLocation = yelpBusinesses![sender.tag]
        performSegue(withIdentifier: Constants.SegueIdentifiers.unwindFromEventLocation, sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.unwindFromEventLocation {
            let createEventController = segue.destination as! CreateEventViewController
            createEventController.location = selectedLocation
        }
    }

}

//MARK: Google Location Search auto-complete
extension LocationSelectorViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationSearchBar.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
        if foodSearchBar.text != "" {
            searchButtonPressed(self)
        }
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

//MARK: Methods for showing and stopping acitivty indicator
extension UIViewController {
    
    func startActivityIndicator(indicator: UIActivityIndicatorView) {
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        // prevents user from interacting while loading
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
 
    func stopActivityIndicator(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        // prevents user from interacting while loading
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
