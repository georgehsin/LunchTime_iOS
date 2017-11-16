//
//  UserDefaults.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/14/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
}