//
//  Constants.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/13/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation

struct Constants {
    
    struct SegueIdentifiers {
        //MARK: Registration/Login Flow
        static let Registration = "showRegistrationVC"
        static let Home = "showHomeVC"
        static let unwindHome = "unwindToHomeVC"
        
        //MARK: Create New Event Flow
        static let eventLocation = "showLocationSelectorVC"
        static let eventDateTime = "showDateTimeSelectorVC"
        static let eventFriends = "showFreindsSelectorVC"
        static let unwindFromEventLocation = "unwindFromEventLocation"
        static let unwindFromEventDate = "unwindFromEventDate"
        static let unwindFromEventFriends = "unwindFromEventFriends"
        static let logout = "logout"
        
        //Segue to additional Event info
        static let eventInfoPage = "showEventInfoPage"
    }
    
    struct Colors {
        static let appOrange = UIColor(red: 222/255, green: 120/255, blue: 38/255, alpha: 1.0)
    }
}
