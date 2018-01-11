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
    
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var selectLocationButton: UIButton!
    @IBOutlet weak var selectFriendsButton: UIButton!
    @IBOutlet weak var createEventButton: UIButton!
    var location: YLPBusiness?
    var friends: [String:Friend]?
    var date: Date?
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var friendField: UITextField!
    
    override func viewDidLoad() {
        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
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
            resetEventData()
            DispatchQueue.global(qos: .default).async {
                self.viewModel.addEvent(date: date, location: location, friends: friends, onComplete: {
                    let alertController = ViewController.createAlert(title: "Event Created!", message: "")
                    self.present(alertController, animated: true, completion: nil)
                })
                
            }
        } else {
            let alertController = ViewController.createAlert(title: "Invalid", message: "Date, Locations, and Friends are required to create an event")
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func resetEventData() {
        location = nil
        friends = nil
        date = nil
        locationField.text = nil
        dateField.text = nil
        friendField.text = nil
    }
 
    func createUI() {
        let buttons: [UIButton] = [selectDateButton, selectLocationButton, selectFriendsButton, createEventButton]
        
        selectDateButton.setTitle("Select Date", for: .normal)
        selectFriendsButton.setTitle("Select Friends", for: .normal)
        selectLocationButton.setTitle("Select Location", for: .normal)
        createEventButton.setTitle("Create Event", for: .normal)
        
        for button in buttons {
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = Constants.Colors.appOrange
            button.roundedButton(corner: [.allCorners], radius: 10, borderColor: Constants.Colors.appOrange)
        }
    }
}
