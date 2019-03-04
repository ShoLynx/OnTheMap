//
//  ParseResponse.swift
//  OnTheMap
//
//  Created by Administrator on 1/15/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct ParseResponse: Codable {
    let code: Int
    let error: String
}

extension ParseResponse: LocalizedError {
    var errorMessage: String? {
        return error
    }
}
