//
//  MovieListModel.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

struct MovieListModel: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults
        case totalPages
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.results = try container.decode([FailableDecodable<Movie>].self, forKey: .results).compactMap { $0.base }
    }

    struct Movie: Decodable {
        let id: Int
        let title: String
        let overview: String
        let posterPath: String
        let releaseDate: String
        let voteAverage: Double
    }
}
