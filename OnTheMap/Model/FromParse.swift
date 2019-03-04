//
//  FromParse.swift
//  OnTheMap
//
//  Created by Administrator on 1/7/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct FromParse: Codable {
    let firstName: String?
    let uniqueKey: String?
    let lastName: String?
    let mediaURL: String?
    let mapString: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case uniqueKey = "key"
        case lastName = "last_name"
        case mediaURL = "address"
        case mapString = "location"
    }
}
