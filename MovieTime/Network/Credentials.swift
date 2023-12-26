//
//  Credentials.swift
//  MovieTime
//
//  Created by Anshul Vyas on 22/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

struct Credentials {    
    static private func fetchBearerToken() throws -> String {
        let fileName: String = "token"
        let fileExtension: String = "json"
        let fileNameWithExtension = fileName + "." + fileExtension
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw FileError.fileNotFound(fileName: fileNameWithExtension)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let tokenData = try jsonDecoder.decode(TokenData.self, from: data)
            return tokenData.bearerToken
        } catch {
            throw FileError.fileDecodingFailed(fileName: fileName, error: error)
        }
    }
    
    static func getBearerTokenHeaderValue() -> String {
        let bearerToken: String
        do {
            bearerToken = try Credentials.fetchBearerToken()
            return "Bearer \(bearerToken)"
        } catch {
            bearerToken = ""
            let fileError = error as! FileError
            print(fileError.localizedDescription)
            return "Bearer \(bearerToken)"
        }
    }
}

struct TokenData: Decodable {
    let bearerToken: String
}
