//
//  FirebaseQuery.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 12/17/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation
import Firebase

class FirebaseQuery {
    
    // reference + query + type(get/update/set)
    
    func getData(docRef: DocumentReference? = nil, colRef: CollectionReference? = nil, onComplete: @escaping (DocumentSnapshot?, Error?)->()) {
        if let docRef = docRef {
            docRef.getDocument(completion: { (querySnapshot, err) in
                onComplete(querySnapshot, err)
            })
        }
    }
    
    func setOrDeleteData(ref: DocumentReference, data: [String: Any], update: Bool) {
        if update {
            ref.setData(data, options: SetOptions.merge())
        } else {
            ref.updateData(data)
        }
    }
}
