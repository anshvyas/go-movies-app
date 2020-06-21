//
//  MovieNetworkServiceMock.swift
//  MovieTimeTests
//
//  Created by Anshul Vyas on 21/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation
@testable import MovieTime

class MovieNetworkServiceMock: NetworkServiceProtocol {
    var completionHandler: ((Result<Any?, HTTPError>) -> Void)?
    var apiData: APIData?
    func makeAPIRequest(data: APIData, completionHandler: @escaping (Result<Any?, HTTPError>) -> Void) {
        self.apiData = data
        self.completionHandler = completionHandler
    }
}
