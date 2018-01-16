
//
//  FriendsSearchViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/27/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import Firebase

class FriendsSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let viewModel = FriendsViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var noResultsView: UIView?
    var noResultsLabel: UILabel?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var getUserDataNeeded: Bool = false
    
    var users: [Friend]?
    var currentUserData: UserData?
    
    @IBAction func segmentedControlSelected(_ sender: UISegmentedControl) {
        searchBar.text = ""
        tableView.isHidden = true
        if let noResultsView = noResultsView {
            noResultsView.isHidden = true
        }
        switch sender.selectedSegmentIndex {
        case 0:
            if getUserDataNeeded {
                getUserData()
                getUserDataNeeded = false
            }
            else {
                tableView.reloadData()
            }
            print("my friends")
        case 1:
            if getUserDataNeeded {
                getUserData()
                getUserDataNeeded = false
            }
            else {
                tableView.reloadData()
            }
            print("pending friend requests")
        default:
            print("Search Friends")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FriendsSearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "friendsCell")
        tableView.isHidden = true
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        hideKeyboardWhenTappedAround()
        getUserData()
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 40, height: 40)
        activityIndicator.backgroundColor = Constants.Colors.backgroundGray
        activityIndicator.layer.cornerRadius = 10
        self.view.addSubview(activityIndicator)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsSearchTableViewCell
        
        let profileImage = UILabel()
        profileImage.textColor = UIColor.white
        profileImage.textAlignment = .center
        profileImage.font.withSize(100)
        profileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        profileImage.layer.cornerRadius = 25
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = Constants.Colors.appOrange
        
        cell.addFriendButton.isHidden = false
        cell.addFriendButton.setImage(UIImage(named: "addContact") , for: .normal)
        cell.addFriendButton.isEnabled = true
        if segmentControl.selectedSegmentIndex == 0 {
            cell.emailLabel.text = currentUserData!.friendsList[indexPath.row].username
            profileImage.text = currentUserData!.friendsList[indexPath.row].username.first?.description.uppercased()
            cell.uid = currentUserData!.friendsList[indexPath.row].uid
            cell.addFriendButton.tag = indexPath.row
            cell.addFriendButton.setImage(UIImage(named: "friend") , for: .normal)
            cell.addFriendButton.isEnabled = false
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            if indexPath.section == 0 {
                cell.emailLabel.text = currentUserData!.recievedRequestUsersLists[indexPath.row].username
                profileImage.text = currentUserData!.recievedRequestUsersLists[indexPath.row].username.first?.description.uppercased()
                cell.uid = currentUserData!.recievedRequestUsersLists[indexPath.row].uid
                cell.addFriendButton.tag = indexPath.row
                cell.addFriendButton.removeTarget(self, action: #selector(addFriendButtonPressed), for: .touchUpInside)
                cell.addFriendButton.addTarget(self, action: #selector(acceptFriendRequestButtonPressed), for: .touchUpInside)
            }
            else {
                cell.emailLabel.text = currentUserData!.sentRequestUsersList[indexPath.row].username
                profileImage.text = currentUserData!.sentRequestUsersList[indexPath.row].username.first?.description.uppercased()
                cell.uid = currentUserData!.sentRequestUsersList[indexPath.row].uid
                cell.addFriendButton.isHidden = true
            }
        }
        else {
            if let users = users {
                let uid = users[indexPath.row].uid
                cell.emailLabel.text = users[indexPath.row].username
                profileImage.text = users[indexPath.row].username.first?.description.uppercased()
                cell.uid = uid
                if currentUserData!.recievedRequestUsersDict.keys.contains(uid) {
                    //Need to show accept button
                    cell.addFriendButton.setImage(UIImage(named: "friend") , for: .normal)
                    cell.addFriendButton.isEnabled = false
                }
                else if currentUserData!.sentRequestUsersDict.keys.contains(uid) {
                    //Need to show pending label
                    cell.addFriendButton.setImage(UIImage(named: "friend") , for: .normal)
                    cell.addFriendButton.isEnabled = false
                }
                else if currentUserData!.friendsDict.keys.contains(uid) {
                    
                    cell.addFriendButton.setImage(UIImage(named: "friend") , for: .normal)
                    cell.addFriendButton.isEnabled = false
                    print("already friends with \(users[indexPath.row].username)")
                }
                else {
                    //!!CHECK if in friends, sent, recieved - don't show these in search results
                    cell.addFriendButton.tag = indexPath.row
                    cell.addFriendButton.removeTarget(self, action: #selector(acceptFriendRequestButtonPressed), for: .touchUpInside)
                    cell.addFriendButton.addTarget(self, action: #selector(addFriendButtonPressed), for: .touchUpInside)
                }
            }
        }
        cell.profileImage.addSubview(profileImage)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        switch segmentControl.selectedSegmentIndex {
        case 0:
            numberOfSections = 1
        case 1:
            numberOfSections = 2
        case 2:
            numberOfSections = 1
        default:
            numberOfSections = 0
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = false
        var numberOfRows = 0
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if let friendsList = currentUserData?.friendsList {
                numberOfRows = friendsList.count
            }
        case 1:
            switch section {
            case 0:
                numberOfRows = currentUserData!.recievedRequestUsersLists.count
            case 1:
                numberOfRows = currentUserData!.sentRequestUsersList.count
            default:
                numberOfRows = 0
            }
        case 2:
            if let users = users {
                tableView.isHidden = false
                numberOfRows = users.count
            }
        default:
            numberOfRows = 0
        }
    
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    let sections = ["Requests Recieved", "Pending Requests"]

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return "Friends"
        case 1:
            return sections[section]
        default:
            return "Search"
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var collection: String?
        switch segmentControl.selectedSegmentIndex {
        case 0:
            collection = "users"
        case 1:
            print()
            //Make search Bar not editable and grayed out
        default:
            collection = "users"
            let search = searchBar.text!.lowercased()
            DispatchQueue.global(qos: .userInteractive).async {
                self.viewModel.queryFireStore(query: search, collection: collection!, field: "email", onComplete: { (usersList) in
                    self.users = usersList
                    DispatchQueue.main.async {
                        if self.users!.count >= 1 {
                            if let noResultsView = self.noResultsView {
                                noResultsView.isHidden = true
                            }
                            self.tableView.reloadData()
                        }
                        else {
                            self.tableView.isHidden = true
                            if let noResultsView = self.noResultsView {
                                noResultsView.isHidden = false
                                self.noResultsLabel!.text = "No users found beginning with \(searchBar.text!)."
                            }
                            else {
                                self.createNoResultsView(query: searchBar.text!)
                            }
                        }
                    }
                })
            }
            
        }

    }
    
    func createNoResultsView(query: String) {
        self.noResultsView = UIView()
        self.noResultsLabel = UILabel()
        self.noResultsView!.frame = self.tableView.frame
        self.view.addSubview(self.noResultsView!)
        self.noResultsLabel!.frame = CGRect(x: 0, y: 0, width: self.noResultsView!.frame.width, height: 200)
        self.noResultsLabel!.text = "No users found beginning with \(query)."
        self.noResultsLabel!.textAlignment = NSTextAlignment.center
        self.noResultsView!.addSubview(self.noResultsLabel!)
    }
    
    func getUserData() {
        startActivityIndicator(indicator: self.activityIndicator)
        if !isInternetAvailable() {
            handleNoNetwork()
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.getCurrentUserData { (userData) in
                self.currentUserData = userData
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addFriendButtonPressed(sender: UIButton) {
        getUserDataNeeded = true
        print("Adding Friend")
        viewModel.sendFriendRequest(recipientUser: users![sender.tag])
    }
    
    @objc func acceptFriendRequestButtonPressed(sender: UIButton) {
        getUserDataNeeded = true
        print("Accepting Friend Request")
        print(sender.tag)
        print(currentUserData!.recievedRequestUsersLists[sender.tag])
        let friend = currentUserData!.recievedRequestUsersLists[sender.tag]
        viewModel.acceptFriendRequest(recipientInfo: friend)
    }
}
