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
    let username = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.email.rawValue)
    
    func addEvent(date: Date, location: YLPBusiness, friends: [String:Friend]) {

        let locationInfo: [String:Any] = ["locationName": location.name, "locationImageUrl": location.imageURL!.absoluteString, "yelpId": location.identifier]
        var eventFriends = friends.mapValues({ (friend) -> [String:Any?] in
            return ["uid": friend.uid, "username": friend.username, "attending": nil]
        })
        eventFriends[uid!] = ["uid": uid, "username": username, "attending": true]
        let eventData: [String: Any] = [
            "creator": ["uid": uid!, "username": username],
            "date": date,
            "location": locationInfo,
            "friends": eventFriends
        ]
        
        //Add Event to Events table
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
                    "locationName": location.name,
                    "locationImageUrl": location.imageURL!.absoluteString,
                    "attending": nil
                ]
            ]
        ]
        
        //Add Event to each Users events Field
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
                        let urlString = value["locationImageUrl"] as! String
                        let locationImageUrl = NSURL(string: urlString)
                        return Event(id: key, date: value["date"] as! Date, locationName: value["locationName"] as! String, locationImageUrl: locationImageUrl!, attending: value["attending"] as? Bool)
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
                    
                    let locationInfo = eventInfo["location"] as! [String:Any]
                    let locationName = locationInfo["locationName"] as! String
                    let locationImageUrl = NSURL(string: locationInfo["locationImageUrl"] as! String)
                    let locationYelpId = locationInfo["yelpId"] as! String
                    
                    let eventCreator = eventInfo["creator"] as! [String:String]
                    let creator = Friend(uid: eventCreator["uid"]!, username: eventCreator["username"]!)
                    let friends = eventInfo["friends"] as! [String: [String:Any]]
                    let friendsList = friends.map({ (key, value) -> Friend in
                        if !(value["attending"] is NSNull) {
                            return Friend(uid: value["uid"] as! String, username: value["username"] as! String, attending: value["attending"] as! Bool!)
                        } else {
                            return Friend(uid: value["uid"] as! String, username: value["username"] as! String)
                        }

                    })
//                    let eventFriends = friends.mapValues({ (friend) -> [String:Any] in
//                        return ["uid": friend["uid"] as! String, "username": friend["username"] as! String, "attending": friend["attending"] as! Bool]
//                    })
                    let event = Event(id: id, date: date, locationName: locationName, locationImageUrl: locationImageUrl!, locationYelpId: locationYelpId, creator: creator, friendsList: friendsList)
                    onComplete(event)
                }
            }
        }
    }
    
    func setAttendingStatus(attending: Bool, eventId: String, onComplete: @escaping () -> ()) {
        let userRef = Firestore.firestore().collection("users").document(uid!)
        userRef.updateData([
            "events.\(eventId).attending": attending
        ])
        let eventRef = Firestore.firestore().collection("events").document(eventId)
        eventRef.updateData([
            "friends.\(uid!).attending": attending
        ])
        onComplete()
    }
}
