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

        let locationInfo = ["name": location.name, "yelpId": location.identifier]
        let eventFriends = friends.mapValues({ (friend) -> [String:Any] in
            return ["uid": friend.uid, "username": friend.username, "attending": false]
        })
        print(eventFriends, locationInfo)
        let eventData: [String: Any] = [
            "date": date,
            "location": locationInfo,
            "friends": eventFriends
        ]
        
        let eventRef = Firestore.firestore().collection("events").addDocument(data: eventData) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
        
        let event = [
            "events": [
                eventRef.documentID: [
                    "date": date,
                    "location": location.name
                ]
            ]
        ]
        Firestore.firestore().collection("users").document(uid!).setData(event, options: SetOptions.merge())
        friends.forEach { (key, value) in
            Firestore.firestore().collection("users").document(key).setData(event, options: SetOptions.merge())
        }
    }
}
