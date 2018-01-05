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
    var firstName: String?
    var lastName: String?
    var phone: String?
    var city: City?
    
    
    var friendsList: [Friend]
    var friendsDict: [String: Friend]
    var sentRequestUsersList: [Friend]
    var recievedRequestUsersLists: [Friend]
    var sentRequestUsersDict: [String: Friend]
    var recievedRequestUsersDict: [String: Friend]

    init(uid: String, email: String, firstName: String? = nil, lastName: String? = nil, phone: String? = nil, city: City? = nil, friendsList: [Friend], friendsDict: [String: Friend], sentRequestList: [Friend], recievedRequestList: [Friend], sentRequestDict: [String: Friend], recievedRequestDict: [String: Friend]) {
        self.uid = uid
        self.email = email
        self.friendsList = friendsList
        self.friendsDict = friendsDict
        self.sentRequestUsersList = sentRequestList
        self.recievedRequestUsersLists = recievedRequestList
        self.sentRequestUsersDict = sentRequestDict
        self.recievedRequestUsersDict = recievedRequestDict
    }
}

struct City {
    var name: String
    var latitude: String
    var longitude: String
    
    init(name: String, latitude: String, longitude: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

