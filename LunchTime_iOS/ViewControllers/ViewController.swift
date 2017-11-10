//
//  ViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/7/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showRegistrationVC", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        emailField.placeholder = "email"
        passwordField.placeholder = "password"
        loginButton.frame = CGRect(x:16, y:view.frame.height - 115, width: view.frame.width - 32, height:50)
        loginButton.delegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with Facebook...")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRegistrationVC" {
            let graphViewController = segue.destination as? RegistrationViewController
            
        }
        
    }
}

