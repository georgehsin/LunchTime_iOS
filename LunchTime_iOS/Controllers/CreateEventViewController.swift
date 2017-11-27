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

    var location: YLPBusiness?
    
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
}
