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
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField: UITextField?
    private var viewModel = UserViewModel()
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showRegistrationVC", sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        switch viewModel.validate() {
        case .Valid:
            viewModel.loginToFirebase()
        case .Invalid(let error):
            print("\(error)")
        }

    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x:16, y:view.frame.height - 115, width: view.frame.width - 32, height:50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        
        emailField.placeholder = "email"
        passwordField.placeholder = "password"
        emailField.delegate = self
        passwordField.delegate = self

    }
    
//    override func viewDidLayoutSubviews() {
//        let screenWidth = UIScreen.main.bounds.width
//        scrollView.contentSize = CGSize(width: screenWidth, height: 600)
//        self.automaticallyAdjustsScrollViewInsets = false
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error)
            return
        }
        
        viewModel.loginToFirebase()
    }
    
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if textField == emailField {
            textField.text = viewModel.username
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            loginButtonPressed(self)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let input = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == emailField {
            viewModel.updateUsername(username: input)
        }
        else if textField == passwordField {
            viewModel.updatePassword(password: input)
        }

        return true
    }
    
}

// MARK: Keyboard NSNotification
extension ViewController {
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        scrollView.isScrollEnabled = false
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//    func registerForKeyboardNotifications(){
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    @objc func keyboardWasShown(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
//            let window = self.view.window?.frame {
//            // We're not just minusing the kb height from the view height because
//            // the view could already have been resized for the keyboard before
//            self.view.frame = CGRect(x: self.view.frame.origin.x,
//                                     y: self.view.frame.origin.y,
//                                     width: self.view.frame.width,
//                                     height: window.origin.y + window.height - keyboardSize.height)
//        } else {
//            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
//        }
//    }
//
//    @objc func keyboardWillBeHidden(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let viewHeight = self.view.frame.height
//            self.view.frame = CGRect(x: self.view.frame.origin.x,
//                                     y: self.view.frame.origin.y,
//                                     width: self.view.frame.width,
//                                     height: viewHeight + keyboardSize.height)
//        } else {
//            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
//        }
//    }
