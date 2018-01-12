//
//  HomeScreenViewController.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/12/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController{
    
    private var yelp = YelpSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Arrived at HomeScreen")
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "add")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

//MARK: Slide out menu
//let menuBackground = UIView()
//var menu: UICollectionView!
//
//
//func setupMenu() {
//    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//    menu = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    menu!.backgroundColor = UIColor.white
//}
//
//
//func showMenu() {
//    if let window = UIApplication.shared.keyWindow, let navController = self.navigationController {
//        menuBackground.backgroundColor = UIColor(white: 0, alpha: 0.5)
//
//        menuBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
//
//        window.addSubview(menuBackground)
//        window.addSubview(menu)
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//        let navBarHeight = navController.navigationBar.frame.size.height
//        let height = window.frame.height - navBarHeight - statusBarHeight
//        let width: CGFloat = 150
//        menu.frame = CGRect(x: -width, y: navBarHeight + statusBarHeight, width: width, height: height)
//
//        menuBackground.frame = window.frame
//        menuBackground.alpha = 0
//
//        UIView.animate(withDuration: 0.5, animations: {
//            self.menuBackground.alpha = 1
//            self.menu.frame = CGRect(x: 0, y: navBarHeight + statusBarHeight, width: width, height: height)
//        })
//    }
//}
//
//@objc func dismissMenu() {
//    print("dismissing")
//    UIView.animate(withDuration: 0.5) {
//        self.menuBackground.alpha = 0
//        if let window = UIApplication.shared.keyWindow, let navController = self.navigationController {
//            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//            let navBarHeight = navController.navigationBar.frame.size.height
//            let height = window.frame.height - navBarHeight - statusBarHeight
//            let width: CGFloat = 150
//            self.menu.frame = CGRect(x: -width, y: navBarHeight + statusBarHeight, width: width, height: height)
//        }
//    }
//}

