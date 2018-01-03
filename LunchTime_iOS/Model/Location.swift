//
//  Location.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 1/3/18.
//  Copyright © 2018 georgehsin. All rights reserved.
//

import Foundation

struct Location {
    var locationName: String
    var locationImageUrl: NSURL
    var locationYelpId: String?
    
    init(locationName: String, locationImageUrl: NSURL, locationYelpId: String? = nil) {
        self.locationName = locationName
        self.locationImageUrl = locationImageUrl
        self.locationYelpId = locationYelpId
    }
}
