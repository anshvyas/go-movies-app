//
//  APIData.swift
//  MovieTime
//
//  Created by Anshul Vyas on 07/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

struct APIData {
    let urlString: String
    let method: HTTPMethod
    let headers: Headers
    
    var allHTTPHeaderFields: [String: String] {
        return headers.headersDict
    }
    
    struct Headers {
        let bearerToken: String
        let contentType: String
        
        var headersDict: [String: String] {
            return [
                "Authorization": self.bearerToken,
                "accept": self.contentType
            ]
        }
    }
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
