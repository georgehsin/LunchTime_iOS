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

struct Event {
    var id: String
    var date: Date
    var locationName: String
    var locationYelpId: String?
    var creator: Friend?
    var friends: [String: Any]?
    
    init(id: String, date: Date, locationName: String) {
        self.id = id
        self.date = date
        self.locationName = locationName
    }
    
    init(id: String, date: Date, locationName: String, locationYelpId: String, creator: Friend, friends: [String:Any]) {
        self.id = id
        self.date = date
        self.locationName = locationName
        self.locationYelpId = locationYelpId
        self.creator = creator
        self.friends = friends
    }
    
}

class EventsViewModel {
    let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
    let username = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.email.rawValue)
    
    func addEvent(date: Date, location: YLPBusiness, friends: [String:Friend]) {

        let locationInfo = ["name": location.name, "yelpId": location.identifier]
        let eventFriends = friends.mapValues({ (friend) -> [String:Any] in
            return ["uid": friend.uid, "username": friend.username, "attending": false]
        })
        print(eventFriends, locationInfo)
        let eventData: [String: Any] = [
            "creator": ["uid": uid!, "username": username],
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
    
    func getAllEvents(onComplete: @escaping ([Event]) -> ()){
        Firestore.firestore().collection("users").document(uid!).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user Data: \(err)")
            }
            else {
                if let querySnapshot = querySnapshot {
                    let user = querySnapshot.data()
                    let events = user["events"] as! [String:[String:Any]]
                    let eventsList = events.map { (key, value) -> Event in
                        return Event(id: key, date: value["date"] as! Date, locationName: value["location"] as! String)
                    }
                    onComplete(eventsList)
                }
            }
        }
    }
    
    func getEvent(eventId: String, onComplete: @escaping (Event) -> ()) {
        Firestore.firestore().collection("events").document(eventId).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user Data: \(err)")
            } else {
                if let querySnapshot = querySnapshot {
                    let eventInfo = querySnapshot.data()
                    let id = querySnapshot.documentID
                    let date = eventInfo["date"] as! Date
                    
                    let locationInfo = eventInfo["location"] as! [String:String]
                    let locationName = locationInfo["name"]!
                    let locationYelpId = locationInfo["yelpId"]!
                    
                    let eventCreator = eventInfo["creator"] as! [String:String]
                    let creator = Friend(uid: eventCreator["uid"]!, username: eventCreator["username"]!)
                    let friends = eventInfo["friends"] as! [String: [String:Any]]
//                    let friendsList = friends.map { (key, value) -> Friend in
//                        return Friend(uid: value["uid"] as String!, username: value["username"] as String!)
//                    }
                    let eventFriends = friends.mapValues({ (friend) -> [String:Any] in
                        return ["uid": friend["uid"] as! String, "username": friend["username"] as! String, "attending": friend["attending"] as! Bool]
                    })
                    let event = Event(id: id, date: date, locationName: locationName, locationYelpId: locationYelpId, creator: creator, friends: eventFriends)
                    onComplete(event)
                }
            }
        }
    }
}
