//
//  EventInfoViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/21/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import YelpAPI

class EventInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var event: Event?
    var yelpInfo: YLPBusiness?
    
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
        eventNib.frame = CGRect(x: 0, y: leadingTopSpace, width: self.view.bounds.width, height: 120)
        self.view.addSubview(eventNib)
        let yelpNib = UINib(nibName: "FriendAttendanceTableViewCell", bundle: nil)
        tableView.register(yelpNib, forCellReuseIdentifier: "attendStatusCell")
        tableView.frame = CGRect(x: 0, y: leadingTopSpace + 120, width: self.view.bounds.width, height: self.view.bounds.height - leadingTopSpace - 120)
        tableView.allowsSelection = false
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 40, height: 40)
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    let sections = ["Creator", "Date", "Friends"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "attendStatusCell", for: indexPath) as! FriendAttendanceTableViewCell
            if indexPath.section == 0 {
                cell.commonInit(email: event!.creator!.username, attending: true)
            } else {
                cell.commonInit(email: event!.friendsList![indexPath.row].username, attending: event!.friendsList![indexPath.row].attending!)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return event!.friends!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

}
