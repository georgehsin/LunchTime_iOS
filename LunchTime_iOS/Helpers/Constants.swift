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
    }
}
