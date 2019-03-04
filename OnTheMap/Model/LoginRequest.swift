//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Administrator on 1/7/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable {
    let username: String
    let password: String
}

