//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Administrator on 1/21/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct LogoutRequest: Codable {
    let sessionRq: SessionRq
    
    enum CodingKeys: String, CodingKey {
        case sessionRq = "session"
    }
}

struct SessionRq: Codable {
    let idRq: String
    let expirationRq: String
    
    enum CodingKeys: String, CodingKey {
        case idRq = "id"
        case expirationRq = "expiration"
    }
}
