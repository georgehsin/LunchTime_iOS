//
//  EventsViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/18/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let viewModel = EventsViewModel()
    let yelpViewModel = YelpSearchViewModel()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var eventsList: [Event]?
    var futureEvents: [Event]?
    var pastEvents: [Event]?
    
    var attending: Bool?
    var event: Event?
    var yelpInfo: YLPBusiness?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        getEvents()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func createUI() {
        let nib = UINib(nibName: "EventsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "eventsCell")
        let preSearchBarHeight = UIApplication.shared.statusBarFrame.height
        tableView.frame = CGRect(x: 0, y: preSearchBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - preSearchBarHeight)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 40, height: 40)
        activityIndicator.backgroundColor = Constants.Colors.backgroundGray
        activityIndicator.layer.cornerRadius = 10
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        guard let event = eventsList?[indexPath.row] else { return cell }
        cell.locationNameLabel.text = event.location.locationName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, h:mm"
        let dateString = dateFormatter.string(from: event.date)
        cell.eventDateLabel.text = dateString
        cell.locationImage.sd_setImage(with: event.location.locationImageUrl as URL)
        cell.additionalEventInfoButton.tag = indexPath.row
        cell.additionalEventInfoButton.addTarget(self, action: #selector(additionalEventInfoButtonPressed), for: .touchUpInside)
        cell.yesButton.tag = indexPath.row
        cell.setYesNoButtons(attending: event.attending)
        cell.yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        cell.noButton.tag = indexPath.row
        cell.noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
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
        startActivityIndicator(indicator: activityIndicator)
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.getAllEvents(onComplete: { (events) in
                let currentDate = Calendar.current.startOfDay(for: Date())
                self.eventsList = events.filter { $0.date > currentDate }.sorted { $0.date < $1.date }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                }
            })
        }
    }
    
    @objc func yesButtonPressed(sender: UIButton) {
        attending = true
        self.eventsList![sender.tag].attending = true
        startActivityIndicator(indicator: activityIndicator)
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.setAttendingStatus(attending: true, eventId: self.eventsList![sender.tag].id, onComplete: {
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                }
            })
        }
    }
    
    @objc func noButtonPressed(sender: UIButton) {
        attending = false
        self.eventsList![sender.tag].attending = false
        startActivityIndicator(indicator: activityIndicator)
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.setAttendingStatus(attending: false, eventId: self.eventsList![sender.tag].id, onComplete: {
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                }
            })
        }
    }
    
    @objc func additionalEventInfoButtonPressed(sender: UIButton) {
        startActivityIndicator(indicator: activityIndicator)
//        requestedEventIndex = sender.tag
        attending = eventsList![sender.tag].attending
        let requestedEventId = eventsList![sender.tag].id
        DispatchQueue.global().async {
            self.viewModel.getEvent(eventId: requestedEventId) { (event) in
                self.event = event
                self.yelpViewModel.findWithYelpId(yelpId: event.location.locationYelpId!) { (result) in
                    self.yelpInfo = result
                    DispatchQueue.main.async {
                        self.stopActivityIndicator(indicator: self.activityIndicator)
                        self.performSegue(withIdentifier: Constants.SegueIdentifiers.eventInfoPage, sender: self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.eventInfoPage {
            let eventInfoController = segue.destination as! EventInfoViewController
            eventInfoController.event = event
            eventInfoController.yelpInfo = yelpInfo
            eventInfoController.attending = attending
        }
    }
}
