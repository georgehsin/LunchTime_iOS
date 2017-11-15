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
        performSegue(withIdentifier: Constants.SegueIdentifiers.Registration, sender: self)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        switch viewModel.validate() {
        case .Valid:
            handleLogin()
        case .Invalid(let error):
            let alertController = UIAlertController(title: "Invalid", message: error, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            self.viewModel.updatePassword(password: "")
            self.passwordField.text = nil
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error)
            return
        }
        
        handleLogin()
    }
    
    func handleLogin() {
        viewModel.loginToFirebase { (errorMsg) in
            if let errorMsg = errorMsg {
                let alertController = UIAlertController(title: "Invalid", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                //Handle, if login success... do the following
                UserDefaults.standard.setIsLoggedIn(value: true)
                self.performSegue(withIdentifier: Constants.SegueIdentifiers.Home, sender: self)
            }
            self.viewModel.updatePassword(password: "")
            self.passwordField.text = nil
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.isLoggedIn() {
            performSegue(withIdentifier: Constants.SegueIdentifiers.Home, sender: self)
        }
    
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x:16, y:view.frame.height - 115, width: view.frame.width - 32, height:50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        
        emailField.placeholder = "email"
        passwordField.placeholder = "password"
        passwordField.isSecureTextEntry = true
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    
//MARK: Unwind Segues
    
    @IBAction func unwindFromRegistration(unwindSegue: UIStoryboardSegue) {
        viewModel.updateUsername(username: emailField.text!)
        //        viewModel.updatePassword(password: passwordField.text!)
        //        loginButtonPressed(self)
    }
    
    @IBAction func logoutButtonPressed(unwindSegue: UIStoryboardSegue) {
        print("logging out")
        UserDefaults.standard.setIsLoggedIn(value: false)
    }
    
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
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
