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

    struct Movie: Decodable {
        let id: Int
        let title: String
        let overview: String
        let posterPath: String
        let releaseDate: String
        let voteAverage: Int
    }
}
