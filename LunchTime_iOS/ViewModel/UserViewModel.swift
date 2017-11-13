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
            return .Invalid("UserName and password are required.")
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
    
    func loginToFirebase() {
//        print("username = \(user.username) password = \(user.password)")
//        print("email = \(email) password = \(password)")
        if user.username != "" {
            Auth.auth().signIn(withEmail: user.username, password: user.password, completion: { (user, error) in
                if let error = error {
                    print("Error with Firebase login \(error)")
                    return
                }
                print("user signed in succesfully")
            })
        }
//        if let email = email, let password = password {
//
//        }
        else {
            let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credentials) { (user, error) in
                if let error = error {
                    print("Error with Firebase login \(error)")
                    return
                }
                print("user signed in succesfully")
            }
        }
    }
    
    func registerWithFirebase() {
        Auth.auth().createUser(withEmail: user.username, password: user.password) { (user, error) in
            if let error = error {
                print("error creating user in Firebase" , error)
                return
            }
            print("successfully created user in Firebase")
        }
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
