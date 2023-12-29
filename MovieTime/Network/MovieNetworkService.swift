//
//  Service.swift
//  MovieTime
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func makeAPIRequest(data: NetworkRequestData, completionHandler: @escaping (Result<Any?, HTTPError>) -> Void)
}

class MovieNetworkService: NetworkServiceProtocol {
    let session: URLSession
    var dataTask: URLSessionTask?
    
    init() {
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }
    
    private func initRequest(data: NetworkRequestData) -> URLRequest? {
        guard let url = self.buildURL(data: data) else {
            return nil
        }
        
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = data.requestType.requestMethod
        request.allHTTPHeaderFields = data.headers
        
        return request
    }
    
    private func buildURL(data: NetworkRequestData) -> URL? {
        switch data.requestType {
        case .get:
            var urlComponents = URLComponents(string: data.urlString)
            
            var urlQueryItems: [URLQueryItem] = []
            for (key, value) in data.params {
                urlQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            urlComponents?.queryItems = urlQueryItems
            
            return urlComponents?.url
        case .post:
            return URL(string: data.urlString)
        }
    }
    
    func makeAPIRequest(data: NetworkRequestData, completionHandler: @escaping (Result<Any?, HTTPError>) -> Void) {
        self.dataTask = nil
        guard let request = self.initRequest(data: data) else {
            return
        }
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(Result.failure(.transportError(error)))
                return
            }
            
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200...299).contains(status) else {
                completionHandler(Result.failure(.serverSideError(status)))
                return
            }
            
            completionHandler(Result.success(data))
        }
        
        self.dataTask = task
        self.dataTask?.resume()
    }
}
