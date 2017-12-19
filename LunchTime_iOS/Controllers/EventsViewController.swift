//
//  EventsViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/18/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let viewModel = EventsViewModel()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var eventsList: [Event]?
    var getEventTest: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getEvents()
        createUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        getEvents()
    }

    func createUI() {
        let nib = UINib(nibName: "EventsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "eventsCell")
        let preSearchBarHeight = UIApplication.shared.statusBarFrame.height
        tableView.frame = CGRect(x: 0, y: preSearchBarHeight, width: self.view.bounds.width, height: self.view.bounds.height)
        tableView.allowsSelection = false
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 40, height: 40)
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        guard let event = eventsList?[indexPath.row] else { return cell }
        cell.locationNameLabel.text = event.location.locationName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM dd - hh:mm"
        let dateString = dateFormatter.string(from: event.date)
        cell.eventDateLabel.text = dateString
        cell.locationImage.sd_setImage(with: event.location.locationImageUrl as! URL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let events = eventsList else { return 0}
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events"
    }
    
    func getEvents() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.getAllEvents(onComplete: { (events) in
                self.eventsList = events
//                self.getEventTest = events[0]
                print(events)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    self.viewModel.getEvent(eventId: self.getEventTest!.id, onComplete: { (event) in
//                        print(event)
//                    })
                }
            })
        }
    }
}
