//
//  FriendSelectorViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/16/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class FriendSelectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = FriendsViewModel()
    let tableView = UITableView()
//    let searchBar = UISearchBar()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let addFriendsButton = UIButton()
    var friendsList = [Friend]()
    var selectedFriends = [String:Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
//        searchBar.delegate = self
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
//        searchBar.frame = CGRect(x: 0, y: preSearchBarHeight, width: self.view.bounds.width-40, height: 40)
//        searchBar.barTintColor = UIColor.white
        tableView.frame = CGRect(x: 0, y: preSearchBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - preSearchBarHeight - 95)
        tableView.allowsSelection = false
        addFriendsButton.frame = CGRect(x: self.view.bounds.width/2 - 58, y: self.view.bounds.height - 90, width: 116, height: 30)
        addFriendsButton.setTitle("add friends", for: .normal)
        addFriendsButton.setTitleColor(UIColor.white, for: .normal)
        addFriendsButton.backgroundColor = Constants.Colors.appOrange
        addFriendsButton.addTarget(self, action: #selector(setFriendsForEvent), for: .touchUpInside)
        addFriendsButton.roundedButton(corner: [.allCorners], radius: 10, borderColor: Constants.Colors.appOrange)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 40, height: 40)
        
//        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(addFriendsButton)
        self.view.addSubview(activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsSearchTableViewCell
        cell.emailLabel.text = friendsList[indexPath.row].username
        cell.uid = friendsList[indexPath.row].uid
        
        let profileImage = UILabel()
        profileImage.text = friendsList[indexPath.row].username.first?.description.uppercased()
        profileImage.textColor = UIColor.white
        profileImage.textAlignment = .center
        profileImage.font.withSize(100)
        profileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = Constants.Colors.appOrange
        cell.profileImage.addSubview(profileImage)
        
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
            createEventController.friendField.text = "\(selectedFriends.count) Friends Selected"
        }
    }
    
    @objc func setFriendsForEvent(sender: UIButton) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.unwindFromEventFriends, sender: sender)
    }
    
    @objc func addFriendButtonPressed(sender: UIButton) {
        let friend = friendsList[sender.tag]
        selectedFriends[friend.uid] = friendsList[sender.tag]
    }
}
