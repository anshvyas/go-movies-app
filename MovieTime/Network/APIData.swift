//
//  APIData.swift
//  MovieTime
//
//  Created by Anshul Vyas on 07/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol NetworkRequestData {
    var requestType: HTTPMethod { get }
    var urlString: String { get }
    var headers: [String: String] { get }
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

struct MovieListAPIData: NetworkRequestData {
    let bearerToken: String
    let contentType: String
    
    var requestType: HTTPMethod = .get
    
    var urlString: String = Constants.movieListUrlString
    
    var headers: [String : String] {
        return [
            "Authorization": self.bearerToken,
            "accept": self.contentType
        ]
    }
}
