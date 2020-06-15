//
//  ImageDownloader.swift
//  GoMovies
//
//  Created by Anshul Vyas on 14/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

class ImageDownloader {
    let memoryCapacity: Int = 50 * 1024 * 1024
    let diskCapacity:  Int = 100 * 1024 * 1024
    let diskPath: String = "GoMoviesImageCache"

    let imageCache: URLCache
    let session: URLSession
    var task: URLSessionDataTask?

    init() {
        self.imageCache = URLCache(memoryCapacity: self.memoryCapacity, diskCapacity: self.diskCapacity, diskPath: self.diskPath)

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = self.imageCache
        self.session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: .main)
    }

    func download(urlString: String, completion: (@escaping (Result<Data, HTTPError>) -> Void)) {
        self.task?.cancel()

        guard let url = URL(string: urlString) else {
            completion(Result.failure(.urlParsingError))
            return
        }

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)

        if let cachedImage = self.imageCache.cachedResponse(for: request) {
            completion(Result.success(cachedImage.data))
            return
        }

        let task = session.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completion(Result.failure(.transportError(error)))
                return
            }
            
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200...299).contains(status) else {
                completion(Result.failure(.serverSideError(status)))
                return
            }

            guard let data = data else {
                completion(Result.failure(.responseParsingError(reason: .emptyData)))
                return
            }

            completion(Result.success(data))
        }

        task.resume()
        self.task = task
    }
}
