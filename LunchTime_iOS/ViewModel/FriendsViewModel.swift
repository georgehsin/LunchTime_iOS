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
    var docId: String
    var username: String
//    var name: String
//    var profilePicURL: String
    
    init(docId: String, username: String ) {
        self.docId = docId
        self.username = username
    }
    
}

class FriendsViewModel {
    
    let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
    
    func queryFireStore(query: String, collection: String, field: String, onComplete: @escaping ([Friend]) -> ()) {
        Firestore.firestore().collection(collection).whereField(field, isGreaterThanOrEqualTo: query).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
//                for document in querySnapshot!.documents {
//                    print(document.documentID)
//                    print(document.data()["email"])
//                }
                let usersList = querySnapshot!.documents.filter({$0.documentID != self.uid}).map({return Friend(docId: $0.documentID, username: $0.data()["email"] as! String)})
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
//                    onComplete(querySnapshot.data()["friends"].map({return Friend(docId: $0.documentId, username: $0.email)}))
                }
            }
        }
    }
    
//    func getCurrentUser() {
//
//    }
    
    func sendFriendRequest(recipientId: String) {
        //get current user add to sentRequest
        //get adding user - add to Request sent
        Firestore.firestore().collection("users").document(uid!).setData(["sentRequest": [recipientId:true] ], options: SetOptions.merge())
        Firestore.firestore().collection("users").document(recipientId).setData(["recievedRequest": [uid!:true] ], options: SetOptions.merge())
    }
    
    func acceptFriendRequest() {
        //get current user - append to Friends array
        //get current user - remove key value from requests recieved
        //get sent request user - remove key value from request sent
    }
    
    func getReference() {
        
    }
}
