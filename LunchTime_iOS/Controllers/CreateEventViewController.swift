//
//  CreateEventViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/16/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.eventLocation {
            let eventLocationController = segue.destination as! LocationSelectorViewController
//            eventLocationController.yelpBusinesses =
        }
    }
    
}
