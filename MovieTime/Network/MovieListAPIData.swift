//
//  MovieListAPIData.swift
//  MovieTime
//
//  Created by Anshul Vyas on 27/12/23.
//  Copyright © 2023 Anshul Vyas. All rights reserved.
//

import Foundation

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
