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
    var sentRequest = [String: Friend]()
    var recievedRequest = [String: Friend]()

    init(uid: String, email: String, friends: [Friend], sentRequest: [String: Friend], recievedRequest: [String: Friend]) {
        self.uid = uid
        self.email = email
        self.friends = friends
        self.sentRequest = sentRequest
        self.recievedRequest = recievedRequest
    }
}

