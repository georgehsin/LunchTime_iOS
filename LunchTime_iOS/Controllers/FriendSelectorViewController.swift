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
    var friendsList = [Friend]()
    var eventFriendsLists = [Friend]()
    
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
        searchBar.frame = CGRect(x: 0, y: preSearchBarHeight, width: self.view.bounds.width, height: 56)
        tableView.frame = CGRect(x: 0, y: preSearchBarHeight + 56, width: self.view.bounds.width, height: self.view.bounds.height - 56)
        
        self.view.addSubview(searchBar)
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
    
    @objc func addFriendButtonPressed(sender: UIButton) {
        eventFriendsLists.append(friendsList[sender.tag])
    }
}
