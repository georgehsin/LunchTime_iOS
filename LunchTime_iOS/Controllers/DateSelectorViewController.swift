//
//  DateSelectorViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/27/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class DateSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.unwindFromEventDate, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.unwindFromEventDate {
            let createEventController = segue.destination as! CreateEventViewController
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
            let dateString = dateFormatter.string(from: datePicker.date)
            createEventController.dateField.text = dateString
        }
    }

}
