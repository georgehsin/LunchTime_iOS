//
//  CreateEventViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/16/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI

class CreateEventViewController: UIViewController {

    let viewModel = EventsViewModel()
    
    var location: YLPBusiness?
    var friends: [String:Friend]?
    var date: Date?
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func selectedLocationUnwind(unwindSegue: UIStoryboardSegue){
        print("location selected")
        locationField.text = location?.name
    }
    
    @IBAction func selectedDateUnwind(unwindSegue: UIStoryboardSegue) {
        print("Date Selected")
//        dateField.text = ""
    }
    
    @IBAction func selectedFriendsUnwind(unwindSegue: UIStoryboardSegue) {
        print("Friends Selected")
    }
    @IBAction func createEventButtonPressed(_ sender: Any) {
        if let date = date, let location = location, let friends = friends {
            DispatchQueue.global(qos: .default).async {
                self.viewModel.addEvent(date: date, location: location, friends: friends)
            }
        } else {
            let alertController = ViewController.createAlert(title: "Invalid", message: "Date, Locations, and Friends are required to create an event")
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
