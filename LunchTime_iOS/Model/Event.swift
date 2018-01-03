//
//  Event.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 1/3/18.
//  Copyright © 2018 georgehsin. All rights reserved.
//

import Foundation

struct Event {
    var id: String
    var date: Date
    var location: Location
    var attending: Bool?
    var creator: Friend?
    var friends: [String: Any]?
    var friendsList: [Friend]?
    
    init(id: String, date: Date, locationName: String, locationImageUrl: NSURL, attending: Bool? = nil) {
        self.id = id
        self.date = date
        self.attending = attending
        self.location = Location(locationName: locationName, locationImageUrl: locationImageUrl)
    }
    
    init(id: String, date: Date, locationName: String, locationImageUrl: NSURL, locationYelpId: String, attending: Bool? = nil, creator: Friend, friends: [String:Any], friendsList: [Friend]) {
        self.id = id
        self.date = date
        self.location = Location(locationName: locationName, locationImageUrl: locationImageUrl, locationYelpId: locationYelpId)
        self.attending = attending
        self.creator = creator
        self.friends = friends
        self.friendsList = friendsList
    }
}
