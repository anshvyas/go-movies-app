//
//  Service.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case transportError(Error)
    case serverSideError(Int)
    case responseParsingError(reason: ResponseParsingErrorReason)

    enum  ResponseParsingErrorReason{
        case emptyData
        case jsonParsingFailed
    }
}

protocol NetworkServiceProtocol {
    func makeAPIRequest(data: APIData, completionHandler: @escaping (Result<Any?, HTTPError>) -> Void)
}

class MovieNetworkService: NetworkServiceProtocol {
    let session: URLSession
    var dataTask: URLSessionTask?

    init() {
        self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }

    private func initRequest(data: APIData) -> URLRequest? {
        guard let url = URL(string: data.urlString) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = data.method.requestMethod
        request.setValue("Bearer \(Constants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.addValue(Constants.contentType, forHTTPHeaderField: "Content-Type")

        return request
    }

    func makeAPIRequest(data: APIData, completionHandler: @escaping (Result<Any?, HTTPError>) -> Void) {
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
