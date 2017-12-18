//
//  EventsViewModel.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/17/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation
import Firebase
import YelpAPI

class EventsViewModel {
    let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
    
    func addEvent(date: Date, location: YLPBusiness, friends: [String:Friend]) {
//        let friendsList = friends.flatMap({ (friend) -> [String:Any] in
//            return [
//                "uid": friend.uid,
//                "username": friend.username,
//                "attending": false
//            ]
//        })
        let location = ["name": location.name, "yelpId": location.identifier]
//        let invitedFriends = friends.map
//        let friendsList = friends.map { (friend) -> [String:Any] in
//            return [
//                "uid": friend.uid,
//                "username": friend.username,
//                "attending": false
//            ]
//        }
        let eventFriends = friends.mapValues({ (friend) -> [String:Any] in
            return ["uid": friend.uid, "username": friend.username, "attending": false]
        })
        print(eventFriends, location)
        let eventData: [String: Any] = [
            "date": date,
            "location": location,
            "friends": eventFriends
        ]
        
        Firestore.firestore().collection("events").addDocument(data: eventData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
}
