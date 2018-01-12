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
        createUI()
        datePicker.minimumDate = Date()
        datePicker.minuteInterval = 5
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.unwindFromEventDate, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.unwindFromEventDate {
            let createEventController = segue.destination as! CreateEventViewController
            createEventController.date = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, YYYY"
            let dateString = dateFormatter.string(from: datePicker.date)
            createEventController.dateField.text = dateString

        }
    }
    
    func createUI(attending: Bool? = nil) {
        submitButton.backgroundColor = Constants.Colors.appOrange
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.roundedButton(corner: [.allCorners], radius: 10, borderColor: Constants.Colors.appOrange)
    }

}
