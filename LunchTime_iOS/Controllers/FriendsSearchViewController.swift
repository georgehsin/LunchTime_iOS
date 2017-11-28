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
    
    var users: [[String:String]]?
    
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsSearchTableViewCell
        if let users = users {
            cell.emailLabel.text = users[indexPath.row]["email"]
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
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print()
        case 1:
            print()
        default:
            let search = searchBar.text!.lowercased()
            viewModel.getFromFireStore(query: search, onComplete: { (usersList) in
                self.users = usersList as? [[String:String]]
                if self.users!.count >= 1 {
                    self.tableView.reloadData()
                }
            })
        }
    }


}
