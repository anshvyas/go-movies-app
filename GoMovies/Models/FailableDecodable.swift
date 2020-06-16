//
//  FailableDecodable.swift
//  GoMovies
//
//  Created by Anshul Vyas on 16/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let singleValuedContainer = try decoder.singleValueContainer()
        self.base = try? singleValuedContainer.decode(Base.self)
    }
}
