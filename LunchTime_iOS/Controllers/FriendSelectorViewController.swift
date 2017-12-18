//
//  FriendSelectorViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/16/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class FriendSelectorViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = FriendsViewModel()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let addFriendsButton = UIButton()
    var friendsList = [Friend]()
    var selectedFriends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        getFriends()
    }

    func createUI() {
        let nib = UINib(nibName: "FriendsSearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "friendsCell")
        let preSearchBarHeight = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        addFriendsButton.frame = CGRect(x: self.view.bounds.width - 40, y: preSearchBarHeight, width: 40, height: 40)
        addFriendsButton.setImage(UIImage(named: "rightArrow") , for: .normal)
        addFriendsButton.backgroundColor = UIColor.lightGray
        addFriendsButton.addTarget(self, action: #selector(setFriendsForEvent), for: .touchUpInside)
        searchBar.frame = CGRect(x: 0, y: preSearchBarHeight, width: self.view.bounds.width-40, height: 40)
        searchBar.backgroundColor = UIColor.lightGray
        tableView.frame = CGRect(x: 0, y: preSearchBarHeight + 40, width: self.view.bounds.width, height: self.view.bounds.height - 40)
        
        self.view.addSubview(searchBar)
        self.view.addSubview(addFriendsButton)
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsSearchTableViewCell
        cell.emailLabel.text = friendsList[indexPath.row].username
        cell.uid = friendsList[indexPath.row].uid
        cell.addFriendButton.tag = indexPath.row
        cell.addFriendButton.addTarget(self, action: #selector(addFriendButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends"
    }
    
    func getFriends() {
        startActivityIndicator(indicator: self.activityIndicator)
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.getFriendsList { (friends) in
                self.friendsList = friends
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.unwindFromEventFriends {
            let createEventController = segue.destination as! CreateEventViewController
            createEventController.friends = selectedFriends
        }
    }
    
    @objc func setFriendsForEvent(sender: UIButton) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.unwindFromEventFriends, sender: sender)
    }
    
    @objc func addFriendButtonPressed(sender: UIButton) {
        selectedFriends.append(friendsList[sender.tag])
    }
}
