//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Administrator on 1/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}


