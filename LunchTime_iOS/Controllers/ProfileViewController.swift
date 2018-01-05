//
//  ProfileViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 1/4/18.
//  Copyright © 2018 georgehsin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GooglePlaces

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let viewModel = FriendsViewModel()
    let userViewModel = UserViewModel()
    let tableView = UITableView()
    var resultsViewController: GMSAutocompleteResultsViewController?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var userAttributes = [String?]()
    let userAttributesLabel = ["Email:", "First Name:", "Last Name:", "Phone:", "City:"]
    var currentUserInfo: UserData?
    
    let scrollView = UIScrollView()
    let layeredView = UIView()
    var activeField: UITextField?
    let firstNameInput = UITextField()
    let lastNameInput = UITextField()
    let phoneInput = UITextField()
    let cityInput = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        getUserData()
        createUI()
        
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
    }
    
    func createUI() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "profileCell")
        tableView.frame = CGRect(x: 0, y: statusBarHeight + 44, width: self.view.frame.width, height: self.view.frame.height - 144 - statusBarHeight)
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        activityIndicator.frame = CGRect(x: self.view.bounds.width/2 - 20, y: self.view.bounds.height/2 - 20, width: 60, height: 60)
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: 44))
        navBar.isTranslucent = false
        let editProfileButton = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 7, width: 50, height: 30))
        editProfileButton.setTitle("edit", for: .normal)
        editProfileButton.setTitleColor(Constants.Colors.appOrange, for: .normal)
        editProfileButton.addTarget(self, action: #selector(editAccountInfo), for: .touchUpInside)
        
        let logoutButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height - 105, width: self.view.frame.width, height: 40))
        logoutButton.setTitle("Logout", for: UIControlState.normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.backgroundColor = Constants.Colors.appOrange
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(logoutButton)
        self.view.addSubview(navBar)
        navBar.addSubview(editProfileButton)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        if currentUserInfo == nil { return cell }
        if let userAttributeValue = userAttributes[indexPath.row] {
            cell.commonInit(attribute: userAttributesLabel[indexPath.row], value: userAttributeValue)
        } else {
            cell.commonInit(attribute: userAttributesLabel[indexPath.row], value: "")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAttributesLabel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func getUserData() {
        startActivityIndicator(indicator: self.activityIndicator)
        DispatchQueue.global(qos: .userInteractive).async {
            self.viewModel.getCurrentUserData { (userData) in
                self.currentUserInfo = userData
                self.userAttributes = [userData.email, userData.firstName, userData.lastName, userData.phone, userData.city?.name]
                DispatchQueue.main.async {
                    self.stopActivityIndicator(indicator: self.activityIndicator)
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    self.createEditAccountInfoModalPopup()
                }
            }
        }
    }
    
    @objc func logout() {
        userViewModel.logoutOfFirebase()
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.removeObject(forKey: UserDefaults.UserDefaultKeys.userId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaults.UserDefaultKeys.email.rawValue)
        UserDefaults.standard.synchronize()
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
        }
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    let editInfoBackground = UIView()
    let editInfoView = UIView()
    
    func createEditAccountInfoModalPopup() {
        editInfoBackground.frame = UIScreen.main.bounds
        editInfoBackground.backgroundColor = UIColor.black
        editInfoBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
        editInfoBackground.alpha = 0
        
        editInfoView.frame = CGRect(x: editInfoBackground.bounds.width/2 - 150, y: editInfoBackground.bounds.height/2 - 225, width: 300, height: 450)
        editInfoView.backgroundColor = UIColor.white
        editInfoView.layer.cornerRadius = 10
        editInfoView.alpha = 0
        scrollView.frame = CGRect(x: 0, y: 0, width: 300, height: 450)
        layeredView.frame = scrollView.frame
        editInfoView.addSubview(scrollView)
        scrollView.addSubview(layeredView)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: editInfoView.frame.height - 40, width: 150, height: 40))
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitleColor(Constants.Colors.appOrange, for: .normal)
        cancelButton.roundedButton(corner: [.topLeft, .bottomLeft], radius: 10, borderColor: Constants.Colors.appOrange)
//        cancelButton.backgroundColor = Constants.Colors.appOrange
        cancelButton.addTarget(self, action: #selector(dismissMenu), for: .touchUpInside)
        let saveButton = UIButton(frame: CGRect(x: 150, y: editInfoView.frame.height - 40, width: 150, height: 40))
        saveButton.setTitle("save", for: .normal)
        saveButton.setTitleColor(Constants.Colors.appOrange, for: .normal)
        saveButton.roundedButton(corner: [.topRight, .bottomRight], radius: 10, borderColor: Constants.Colors.appOrange)
//        saveButton.backgroundColor = Constants.Colors.appOrange
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        
        self.tabBarController!.view.addSubview(editInfoBackground)
        self.tabBarController!.view.addSubview(editInfoView)
//        self.navigationController!.view.addSubview(editInfoBackground)
//        self.navigationController!.view.addSubview(editInfoView)
        
        let emailLabel = UILabel()
        emailLabel.textAlignment = .center
        emailLabel.textColor = UIColor.gray
        emailLabel.layer.borderWidth = 1
        emailLabel.layer.borderColor = UIColor.gray.cgColor
        emailLabel.frame = CGRect(x: 25, y: 50, width: 250, height: 40)
        emailLabel.layer.cornerRadius = 10
        emailLabel.clipsToBounds = true
        emailLabel.text = currentUserInfo!.email
        
        firstNameInput.frame = CGRect(x: 25, y: 120, width: 250, height: 40)
        firstNameInput.text = currentUserInfo!.firstName ?? ""
        firstNameInput.placeholder = currentUserInfo!.firstName == nil ? "first name not set" : ""
        lastNameInput.frame = CGRect(x: 25, y: 190, width: 250, height: 40)
        lastNameInput.text = currentUserInfo!.lastName ?? ""
        lastNameInput.placeholder = currentUserInfo!.firstName == nil ? "last name not set" : ""
        phoneInput.frame = CGRect(x: 25, y: 260, width: 250, height: 40)
        phoneInput.text = currentUserInfo!.phone ?? ""
        phoneInput.placeholder = currentUserInfo!.firstName == nil ? "phone number not set" : ""
        cityInput.frame = CGRect(x: 25, y: 330, width: 250, height: 40)
        cityInput.text = currentUserInfo!.city?.name ?? ""
        cityInput.tag = 1
        cityInput.placeholder = currentUserInfo!.firstName == nil ? "city not set" : ""
        
        let inputFields = [firstNameInput, lastNameInput, phoneInput, cityInput]
        
        for field in inputFields {
            field.textAlignment = .center
            field.borderStyle = .line
            field.layer.cornerRadius = 10
            field.layer.masksToBounds = true
            layeredView.addSubview(field)
            field.delegate = self
        }
        
        layeredView.addSubview(emailLabel)
        layeredView.addSubview(cancelButton)
        layeredView.addSubview(saveButton)
    }
    
    @objc func editAccountInfo() {
        self.tabBarController!.tabBar.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.editInfoBackground.alpha = 0.4
            self.editInfoView.alpha = 1
        })
    }
    
    @objc func dismissMenu() {
        self.tabBarController!.tabBar.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.editInfoBackground.alpha = 0
            self.editInfoView.alpha = 0
        })
        layeredView.endEditing(true)
    }
    
    @objc func saveButtonPressed() {
        dismissMenu()
        currentUserInfo?.firstName = firstNameInput.text ?? nil
        currentUserInfo?.lastName =  lastNameInput.text ?? nil
        currentUserInfo?.phone = phoneInput.text ?? nil
        userViewModel.updateUserInfo(userInfo: currentUserInfo!)
    }
}

// MARK: UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if textField.tag == 1 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameInput {
            lastNameInput.becomeFirstResponder()
        }
        else if textField == lastNameInput {
            phoneInput.becomeFirstResponder()
        }
        else if textField == phoneInput {
            cityInput.becomeFirstResponder()
        }
        else {
            saveButtonPressed()
        }
        return true
    }

}

// MARK: Keyboard NSNotification
extension ProfileViewController {
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWasShown(notification: NSNotification){
        scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let heightToSubtract = keyboardSize!.height - ((self.view.frame.height - 450)/2)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, heightToSubtract, 0.0)
        scrollView.contentSize = CGSize(width: 300, height: 460)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let heightToAdd = keyboardSize!.height - ((self.view.frame.height - 450)/2)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -heightToAdd, 0.0)
        scrollView.contentSize = CGSize(width: 300, height: 450)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.isScrollEnabled = false
    }
    
}

//MARK: Google Location Search auto-complete
extension ProfileViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        cityInput.text = place.formattedAddress
        currentUserInfo?.city?.name = place.formattedAddress ?? ""
        currentUserInfo?.city?.latitude = place.coordinate.latitude.description
        currentUserInfo?.city?.longitude = place.coordinate.longitude.description
        //save coordinates and use that to search in app
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

