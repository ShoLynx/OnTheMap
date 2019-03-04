//
//  SearchResults.swift
//  OnTheMap
//
//  Created by Administrator on 1/20/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    let results: [StudentLocation]
}

struct StudentLocation: Codable {
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let uniqueKey: String?
}

struct MapPool {
    static var results = [StudentLocation]()
}
