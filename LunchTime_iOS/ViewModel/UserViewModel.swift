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
    private let minPasswordLength = 6
    private var user = User()
    
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
        
        if user.password.characters.count < minPasswordLength {
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
    
    func loginToFirebase(onComplete: @escaping (String?) -> ()) {
        print("username = \(user.username) password = \(user.password)")
//        print("email = \(email) password = \(password)")
        var errorMsg: String?
        if let facebookToken = FBSDKAccessToken.current() {
            let credentials = FacebookAuthProvider.credential(withAccessToken: facebookToken.tokenString)
            Auth.auth().signIn(with: credentials) { (user, error) in
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
                onComplete(errorMsg)
            }
        }
        else {
            Auth.auth().signIn(withEmail: user.username, password: user.password, completion: { (user, error) in
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
                onComplete(errorMsg)
            })
        }
    }
    
    func registerWithFirebase(onComplete: @escaping (String?) -> ()) {
        var errorMsg: String?
        Auth.auth().createUser(withEmail: user.username, password: user.password) { (user, error) in
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
            onComplete(errorMsg)
        }
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
        
        print("Successfully logged in with Facebook...")
    }
}
