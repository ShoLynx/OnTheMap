//
//  UResponse.swift
//  OnTheMap
//
//  Created by Administrator on 1/16/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct UResponse: Codable {
    let status: String
    let error: String
}

extension UResponse: LocalizedError {
    var errorMessage: String? {
        return error
    }
}
