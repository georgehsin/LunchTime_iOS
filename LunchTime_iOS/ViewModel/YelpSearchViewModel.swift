//
//  YelpSearchViewModel.swift
//  LunchTime_iOS
//
//  Created by George Hsin on 11/19/17.
//  Copyright © 2017 georgehsin. All rights reserved.
//

import Foundation
import YelpAPI

struct YelpBusiness: Decodable {
    let rating: Int
    let price: String
    let phone: String
    let id: String
    let is_closed: String
    let categories: Categories
    let review_count: Int
    let name: String
    let url: String
    let coordinates: Coordinates
    let image_url: String
    let location: Location
    let distance: Double
    let transaction: [String]
}

struct Categories: Decodable {
    let alias: String
    let title: String
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

struct Location: Decodable {
    let city: String
    let country: String
    let address2: String
    let address3: String
    let state: String
    let address1: String
    let zipcode: String
}



class YelpSearchViewModel {
    
    let appId = "epaxlQQOHCGxzbL65kJr9A"
    let appSecret = "uOrkUAPJtY5ou7jffTKszKy4W8LfvHyCFKJjBWoZLQvCecmpNKIZfGgMDkqqad0h"
    
    func queryYelp(term: String = "", location: String, completion: @escaping ([YLPBusiness]) -> ()) {
        // Search for 3 dinner restaurants
        let query = YLPQuery(location: location)
        query.term = term
        query.limit = 20
        
        YLPClient.authorize(withAppId: appId, secret: appSecret) { (YLPClient, Error) in
            if let yelp = YLPClient {
                yelp.search(with: query, completionHandler: { (search, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        if let results = search?.businesses {
                            completion(results)
                        }
                    }
                })
            }
        }
    }
    
    
}


