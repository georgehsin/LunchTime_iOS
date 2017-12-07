//
//  CurrentUser.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/12/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation

struct CurrentUser {
    var username: String = ""
    var password: String = ""
    var data: UserData?
}

struct UserData {
    var uid = ""
    var email = ""
//    var profilePic
    var friends = [Friend]()
    var sentRequestUsersList = [Friend]()
    var recievedRequestUsersLists = [Friend]()
    var sentRequestUsersDict = [String: Friend]()
    var recievedRequestUsersDict = [String: Friend]()

    init(uid: String, email: String, friends: [Friend], sentRequestList: [Friend], recievedRequestList: [Friend], sentRequestDict: [String: Friend], recievedRequestDict: [String: Friend]) {
        self.uid = uid
        self.email = email
        self.friends = friends
        self.sentRequestUsersList = sentRequestList
        self.recievedRequestUsersLists = recievedRequestList
        self.sentRequestUsersDict = sentRequestDict
        self.recievedRequestUsersDict = recievedRequestDict
    }
}

