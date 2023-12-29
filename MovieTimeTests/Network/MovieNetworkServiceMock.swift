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
    var cancelAPIRequestCalled: Bool = false
    func cancelAPIRequest() {
        self.cancelAPIRequestCalled = true
    }
    
    var completionHandler: ((Result<Any?, HTTPError>) -> Void)?
    var apiData: NetworkRequestData?
    func makeAPIRequest(data: NetworkRequestData, completionHandler: @escaping (Result<Any?, HTTPError>) -> Void) {
        self.apiData = data
        self.completionHandler = completionHandler
    }
}
