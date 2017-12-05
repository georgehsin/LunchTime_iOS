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
    
    var users: [Friend]?
    
    @IBAction func segmentedControlSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("my friends")
        case 1:
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
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        getFriends()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsSearchTableViewCell
        if let users = users {
            //cell.reference = *****
            //use this as the reference and add this as the sent_request array
            cell.emailLabel.text = users[indexPath.row].username
            cell.uid = users[indexPath.row].docId
            cell.addFriendButton.tag = indexPath.row
            cell.addFriendButton.addTarget(self, action: #selector(addFriendButtonPressed), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = users {
            tableView.isHidden = false
            return users.count
        }
        else {
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var collection: String?
        switch segmentControl.selectedSegmentIndex {
        case 0:
            collection = "users"
        case 1:
            collection = "users"
        default:
            collection = "users"
        }
        let search = searchBar.text!.lowercased()
        viewModel.queryFireStore(query: search, collection: collection!, field: "email", onComplete: { (usersList) in
            self.users = usersList
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
        })
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
    
    func getFriends() {
        let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
        viewModel.getFromFireStore(collection: "users", document: uid!, onComplete: { (user) in
            print(user)
//            print(user["email"]! as! String)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFriends()
    }
    
    @objc func addFriendButtonPressed(sender: UIButton) {
        print("Sending a friend request to \(users![sender.tag].username)")
        print("user uid is \(users![sender.tag].docId)")
        viewModel.sendFriendRequest(recipientId: users![sender.tag].docId)
    }



}
