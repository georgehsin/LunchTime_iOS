//
//  EventsViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/18/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    let viewModel = EventsViewModel()
    var eventsList: [Event]?
    var getEventTest: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func getEvents() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.getAllEvents(onComplete: { (events) in
                self.eventsList = events
                self.getEventTest = events[0]
                print(events)
                DispatchQueue.main.async {
                    //Do Something with loaded data on Main thread
                    //self.tableView.reloadData()
                    self.viewModel.getEvent(eventId: self.getEventTest!.id, onComplete: { (event) in
                        print(event)
                    })
                }
            })
        }
    }

}
