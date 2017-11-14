//
//  MainNavigationController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/13/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//
//
//import UIKit
//
//class MainNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("MainNav")
//        if isLoggedIn() {
//            print("preparing to present HomeScreen")
//
//            performSegue(withIdentifier: "autoLogin", sender: self)
//        }
//        else {
//            // need to present after entire application window has been loaded
//            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
//        }
//    }
//    
//    @objc func showLoginController() {
//        let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! ViewController
//        present(loginController, animated: true, completion: {
//            //Do something
//        })
//    }
//    
//    fileprivate func isLoggedIn() -> Bool {
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
//}

