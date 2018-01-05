//
//  UserViewModel.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/12/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

enum UserValidationState {
    case Valid
    case Invalid(String)
}

class UserViewModel {
    let uid = UserDefaults.standard.string(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
    private let minPasswordLength = 6
    private var user = CurrentUser()
    
    var username: String {
        return user.username
    }
    
    var password: String {
        return user.password
    }
    
}


// MARK: extension for setters and getters for UserViewModel
extension UserViewModel {
    func updateUsername(username: String) {
        user.username = username
    }
    
    func updatePassword(password: String) {
        user.password = password
    }
    
    func validate(register: Bool = false, confirmationPassword: String? = nil) -> UserValidationState {
        print("username = \(user.username) password = \(user.password)")
        if user.username.isEmpty || user.password.isEmpty {
            return .Invalid("Username and password are required.")
        }
        
        if user.password.count < minPasswordLength {
            return .Invalid("Password needs to be at least \(minPasswordLength) characters long.")
        }
        
        if register {
            if let confirmationPassword = confirmationPassword {
                if confirmationPassword != user.password {
                        return .Invalid("Passwords do not match.")
                }
            }
        }
        
        return .Valid
    }
}


//MARK: Network login and registration
extension UserViewModel {
    
    func loginToFirebase(onComplete: @escaping (User?, String?) -> ()) {
        print("username = \(user.username) password = \(user.password)")
//        print("email = \(email) password = \(password)")
        var errorMsg: String?
        if let facebookToken = FBSDKAccessToken.current() {
            let credentials = FacebookAuthProvider.credential(withAccessToken: facebookToken.tokenString)
            Auth.auth().signIn(with: credentials) { (FirebaseUser, error) in
                if error != nil  {
//                    print("Error with Firebase login \(error)")
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .emailAlreadyInUse:
                            errorMsg = "in use"
                        default:
                            errorMsg = "unsuccessful login, please try a different username/password"
                        }
                    }
                }
                onComplete(FirebaseUser, errorMsg)
            }
        }
        else {
            Auth.auth().signIn(withEmail: user.username, password: user.password, completion: { (FirebaseUser, error) in
                if error != nil {
                    print("error")
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .invalidEmail:
                            errorMsg = "invalid email"
                        case .emailAlreadyInUse:
                            errorMsg = "in use"
                        case .userNotFound:
                            errorMsg = "User not found, please register user"
                        case .wrongPassword:
                            errorMsg = "Incorrect user password"
                        default:
                            errorMsg = "unsuccessful login, please try a different username/password"
                        }
                    }
                }
                onComplete(FirebaseUser, errorMsg)
            })
        }
    }
    
    func registerWithFirebase(onComplete: @escaping (String?) -> ()) {
        var errorMsg: String?
        Auth.auth().createUser(withEmail: user.username, password: user.password) { (FirebaseUser, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        errorMsg = "invalid email"
                    case .emailAlreadyInUse:
                        errorMsg = "Email already in use"
                    default:
                        errorMsg = "unsuccessful registration, please try a different username"
                    }
                }
            }
            else if let FirebaseUser = FirebaseUser {
                self.writeUserToDatabase(uid: FirebaseUser.uid)
            }
            onComplete(errorMsg)
        }
        
    }
    
    func writeUserToDatabase(uid: String) {
        DispatchQueue.global().async {
            if FBSDKAccessToken.current() != nil {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil) {
                        let fbData = result as! [String:String]
                        let docData: [String: Any] = [
                            "email": fbData["email"]!,
                            "friends": [String: Friend](),
                            "events": [String: Event](),
                            "sentRequest": [String: Friend](),
                            "recievedRequest": [String: Friend]()
                        ]
                        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added")
                            }
                        }
                    }
                })
            }
            else {
                let docData: [String: Any] = [
                    "email": self.user.username,
                    "friends": [String: Friend](),
                    "events": [String: Event](),
                    "sentRequest": [String: Friend](),
                    "recievedRequest": [String: Friend]()
                ]
                Firestore.firestore().collection("users").document(uid).setData(docData) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added")
                    }
                }
            }
            
        }
    }
    
    func updateUserInfo(userInfo: UserData) {
        let userInfo: [String: String?] = [
            "firstName": userInfo.firstName ?? nil,
            "lastName": userInfo.lastName,
            "phone": userInfo.phone,
            "city": userInfo.city?.name,
            "latitude": userInfo.city?.latitude,
            "longitude": userInfo.city?.longitude
        ]
        Firestore.firestore().collection("users").document(self.uid!).updateData(
            userInfo
        )
//            .setData(userInfo) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added")
//            }
//        }
        
    }
    
    func logoutOfFirebase() {
        if let currentUser = Auth.auth().currentUser {
            print(currentUser)
        }
        try! Auth.auth().signOut()
        
    }
    
    func getFBInfo() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            if err != nil {
                print("Failed to start FB graph request", err!)
                return
            }
            print(result!)
        }
    }
}
