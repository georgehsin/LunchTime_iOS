//
//  HomeScreenViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/12/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Arrived at HomeScreen")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
