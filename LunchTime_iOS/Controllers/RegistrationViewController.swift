
//
//  RegistrationViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/9/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    private var viewModel = UserViewModel()
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        switch viewModel.validate(register: true, confirmationPassword: passwordConfirmField.text) {
        case .Valid:
            viewModel.registerWithFirebase { (errorMsg) in
                if let errorMsg = errorMsg {
                    let alertController = UIAlertController(title: "Invalid", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    //Handle, if registration success... do the following
                    self.performSegue(withIdentifier: Constants.SegueIdentifiers.unwindHome, sender: self)
                }
            }
        case .Invalid(let error):
            print("\(error)")
            let alertController = UIAlertController(title: "Invalid", message: error, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfirmField.delegate = self
    }

    func setUI() {
        emailField.placeholder = "email"
        passwordField.placeholder = "password"
        passwordConfirmField.placeholder = "confirm password"
        passwordField.isSecureTextEntry = true
        passwordConfirmField.isSecureTextEntry = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.unwindHome {
            let loginController = segue.destination as! ViewController
            loginController.emailField.text = emailField.text
//            loginController.passwordField.text = passwordField.text
        }
    }
}

// MARK: UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
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
        switch textField {
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            passwordConfirmField.becomeFirstResponder()
        default:
            registerButtonPressed(self)
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
extension RegistrationViewController {

    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func UIKeyboardWillShow(notification: NSNotification) {
        
    }
    
    @objc func keyboardDidShow(notification: NSNotification){
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

