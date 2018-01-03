//
//  Friend.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 1/3/18.
//  Copyright © 2018 georgehsin. All rights reserved.
//

import Foundation

struct Friend {
    var uid: String
    var username: String
    var attending: Bool?
    //    var name: String
    //    var profilePicURL: String
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    
    init(uid: String, username: String, attending: Bool) {
        self.uid = uid
        self.username = username
        self.attending = attending
    }
    
}
