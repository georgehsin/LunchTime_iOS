//
//  FriendsViewModel.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/27/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation
import Firebase

struct Friend {
    var uid: String
    var username: String
//    var name: String
//    var profilePicURL: String
    
    init(uid: String, username: String ) {
        self.uid = uid
        self.username = username
    }
    
}

class FriendsViewModel {
    
    let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
    var currentUser = CurrentUser()
    
//    func getFromFireStore(query: String, collection: String, field: String, onComplete: @escaping (Any) -> ()) {
//        Firestore.firestore().collection(collection).whereField(field, isGreaterThanOrEqualTo: query).whereField("email", isLessThan: "\(query)z").getDocuments()
    
    func queryFireStore(query: String, collection: String, field: String, onComplete: @escaping ([Friend]) -> ()) {
        Firestore.firestore().collection(collection).whereField(field, isGreaterThanOrEqualTo: query).whereField("email", isLessThan: "\(query)z") .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let usersList = querySnapshot!.documents.filter({$0.documentID != self.uid}).map({return Friend(uid: $0.documentID, username: $0.data()["email"] as! String)})
                print("FriendsViewModel.getFromFireStore() - userList: \(usersList)")
                onComplete(usersList)
            }
        }
    }
    
    //get collection function
    func getFromFireStore(collection: String, document: String, onComplete: @escaping ([Friend]) -> ()) {
        Firestore.firestore().collection(collection).document(document).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let querySnapshot = querySnapshot {
                    print(querySnapshot.data())
                    print("FriendsViewModel.getFromFireStore() - userList: \(querySnapshot)")
//                    onComplete(querySnapshot.data()["friends"].map({return Friend(uid: $0.documentId, username: $0.email)}))
                }
            }
        }
    }
    
    func getCurrentUserData(onComplete: @escaping (UserData) -> ()){
        Firestore.firestore().collection("users").document(uid!).getDocument() { (querySnapshot, err) in
            if let err = err {
                print("Error getting user Data: \(err)")
            }
            else {
                if let querySnapshot = querySnapshot {
                    let user = querySnapshot.data()
                    let uid = querySnapshot.documentID
                    let email = user["email"] as! String
                    let friends = user["friends"] as! [Friend]
                    
                    let sentRequest = user["sentRequest"] as! [String: [String:String]]
                    let sentRequestList = sentRequest.map { (key, value) -> Friend in
                        return Friend(uid: value["uid"] as String!, username: value["username"] as String!)
                    }
                    let sentRequestDict = sentRequest.mapValues({ (value) -> Friend in
                        return Friend(uid: value["uid"]!, username: value["username"]!)
                    })
                    
                    let recievedRequest = user["recievedRequest"] as! [String: [String:String]]
                    //map into array of [Friend] objects with uid and email
                    let recievedRequestList = recievedRequest.map { (key, value) -> Friend in
                        return Friend(uid: value["uid"] as String!, username: value["username"] as String!)
                    }
                    let recievedRequestDict = recievedRequest.mapValues({ (value) -> Friend in
                        return Friend(uid: value["uid"]!, username: value["username"]!)
                    })
                    
                    self.currentUser.data = UserData.init(uid: uid, email: email, friends: friends, sentRequestList: sentRequestList, recievedRequestList: recievedRequestList, sentRequestDict: sentRequestDict, recievedRequestDict: recievedRequestDict)
                    onComplete(self.currentUser.data!)
                }
            }
        }
    }
    
    func sendFriendRequest(recipientUser: Friend) {
        //get current user add to sentRequest
        //get adding user - add to Request sent
        let recipientId = recipientUser.uid
        let sentRequestData = [
            "sentRequest": [
                recipientId: [
                    "uid": recipientId,
                    "username": recipientUser.username
                ]
            ]
        ]
        let recievedRequestData = [
            "recievedRequest": [
                uid!: [
                    "uid": uid!,
                    "username": currentUser.data?.email
                ]
            ]
        ]
        Firestore.firestore().collection("users").document(uid!).setData(sentRequestData, options: SetOptions.merge())
        Firestore.firestore().collection("users").document(recipientId).setData(recievedRequestData, options: SetOptions.merge())
    }
    
    func acceptFriendRequest(recipientId: String) {
        //get current user - append to Friends array
        //get current user - remove key value from requests recieved
        //get sent request user - remove key value from request sent
        print(uid!, recipientId)
        Firestore.firestore().collection("users").document(uid!).updateData([
//            "friends": [],
            "recievedRequest.\(recipientId)": FieldValue.delete()
        ])
        Firestore.firestore().collection("users").document(recipientId).updateData([
            //PROBLEM - how to remove from recipient users dict
            //only way for now - get user sentRequest dict, and then set it
//            "friends": [],
            "sentRequest.\(uid!)": FieldValue.delete()
            ])
        
        // easiest is to get entire document(friend) and replace with updateed local
    }
    
    func getReference() {
        
    }
}
