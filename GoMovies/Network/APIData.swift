//
//  APIData.swift
//  GoMovies
//
//  Created by Anshul Vyas on 07/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

struct APIData {
    let urlString: String
    let method: HTTPMethod
}

enum HTTPMethod {
    case get
    case post

    var requestMethod: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
