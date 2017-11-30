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
    
    func getFromFireStore(query: String, collection: String, field: String, onComplete: @escaping (Any) -> ()) {
        Firestore.firestore().collection(collection).whereField(field, isGreaterThanOrEqualTo: query).whereField("email", isLessThan: "\(query)z") .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let usersList = querySnapshot!.documents.map({return $0.data()})
                onComplete(usersList)
            }
        }
    }
    
}
