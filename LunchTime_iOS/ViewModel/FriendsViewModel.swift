//
//  FriendsViewModel.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/27/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation
import Firebase

class FriendsViewModel {
    
    func getFromFireStore(query: String, onComplete: @escaping (Any) -> ()) {
        Firestore.firestore().collection("users").whereField("email", isEqualTo: query).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    print(document)
//                }
                let usersList = querySnapshot!.documents.map({return $0.data()})
                onComplete(usersList)
            }
        }
    }
}
