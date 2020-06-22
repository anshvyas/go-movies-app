//
//  HTTPError.swift
//  MovieTime
//
//  Created by Anshul Vyas on 15/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case transportError(Error)
    case serverSideError(Int)
    case responseParsingError(reason: ResponseParsingErrorReason)
    case imageDownloadingError(Error)
    case urlParsingError

    enum  ResponseParsingErrorReason{
        case emptyData
        case jsonParsingFailed
    }
}
