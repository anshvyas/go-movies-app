//
//  Service.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

enum HttpMethod {
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

class Service {
    let session = URLSession.shared
    let urlString: String
    let httpMethod: HttpMethod

    var request: URLRequest?
    var dataTask: URLSessionTask?

    init(urlString: String, httpMethod: HttpMethod) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.initRequest()
    }

    private func initRequest() {
        guard let url = URL(string: self.urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.requestMethod
        request.setValue("Bearer \(Constants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.addValue(Constants.contentType, forHTTPHeaderField: "Content-Type")

        self.request = request
    }

    func makeAPIRequest() {
        guard let request = self.request else {
            return
        }

        let task = self.session.dataTask(with: request) { (data, response, error) in
            //TODO: Completion Handlers
        }

        self.dataTask = task
        self.dataTask?.resume()
    }
}
