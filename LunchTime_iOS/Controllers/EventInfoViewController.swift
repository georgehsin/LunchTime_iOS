//
//  EventInfoViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/21/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI
import MapKit

class EventInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = EventsViewModel()
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
    var event: Event?
    var yelpInfo: YLPBusiness?
    var attending: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func createUI() {
        let leadingTopSpace = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        let eventNib = Bundle.main.loadNibNamed("YelpLocationTableViewCell", owner: self, options: nil)?[0] as! YelpLocationTableViewCell
        eventNib.commonInit(business: yelpInfo!)
        eventNib.selectButton.setTitle("View in Maps", for: .normal)
        eventNib.selectButton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        eventNib.frame = CGRect(x: 0, y: leadingTopSpace, width: self.view.bounds.width, height: 120)
        self.view.addSubview(eventNib)
        let friendNib = UINib(nibName: "FriendAttendanceTableViewCell", bundle: nil)
        tableView.register(friendNib, forCellReuseIdentifier: "attendStatusCell")
        let dateNib = UINib(nibName: "EventDateAttendanceTableViewCell", bundle: nil)
        tableView.register(dateNib, forCellReuseIdentifier: "dateCell")
        tableView.frame = CGRect(x: 0, y: leadingTopSpace + 120, width: self.view.bounds.width, height: self.view.bounds.height - leadingTopSpace - 120)
        tableView.allowsSelection = false
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 40, height: 40)
        activityIndicator.backgroundColor = Constants.Colors.backgroundGray
        activityIndicator.layer.cornerRadius = 10
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    let sections = ["Creator", "Date", "Friends"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! EventDateAttendanceTableViewCell
            cell.commonInit(date: event!.date, attending: attending)
            cell.yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
            cell.noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "attendStatusCell", for: indexPath) as! FriendAttendanceTableViewCell
            if indexPath.section == 0 {
                cell.commonInit(email: event!.creator!.username, attending: true)
                if event!.creator!.uid == uid {
                    cell.attendanceStatusLabel.setTitle("delete", for: .normal)
                    cell.attendanceStatusLabel.setTitleColor(UIColor.white, for: .normal)
                    cell.attendanceStatusLabel.backgroundColor = UIColor.red
                    cell.attendanceStatusLabel.roundedButton(corner: [.allCorners], radius: 10, borderColor: UIColor.red)
                }
            } else {
                if event!.creator!.uid == event!.friendsList![indexPath.row].uid {
                    cell.isHidden = true
                    return cell
                }
                if let attending = event!.friendsList![indexPath.row].attending {
                    cell.commonInit(email: event!.friendsList![indexPath.row].username, attending: attending)
                } else {
                    cell.commonInit(email: event!.friendsList![indexPath.row].username)
                }

            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return event!.friendsList!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && event!.creator!.uid == event!.friendsList![indexPath.row].uid {
            return 0
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    @objc func yesButtonPressed(sender: UIButton) {
        startActivityIndicator(indicator: activityIndicator)
        if !isInternetAvailable() {
            handleNoNetwork()
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.setAttendingStatus(attending: true, eventId: self.event!.id, onComplete: {
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                }
            })
        }
    }
    
    @objc func noButtonPressed(sender: UIButton) {
        startActivityIndicator(indicator: activityIndicator)
        if !isInternetAvailable() {
            handleNoNetwork()
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.setAttendingStatus(attending: false, eventId: self.event!.id, onComplete: {
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                }
            })
        }
    }
    
    @objc func openInMaps(sender: UIButton) {
        let latitude: CLLocationDegrees = yelpInfo!.location.coordinate!.latitude
        let longitude: CLLocationDegrees = yelpInfo!.location.coordinate!.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = yelpInfo!.name
        mapItem.openInMaps(launchOptions: options)
    }

}
