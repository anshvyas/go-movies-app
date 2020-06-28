//
//  MovieListModelTests.swift
//  MovieTimeTests
//
//  Created by Anshul Vyas on 28/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import XCTest
@testable import MovieTime

class MovieListModelTests: XCTestCase {
    var movieListModel: MovieListModel!
    override func setUpWithError() throws {
        let jsonData = """
        {
            "page": 1,
            "total_results": 2,
            "total_pages": 1,
            "results": [
                {
                    "popularity": 214.043,
                    "vote_count": 357,
                    "video": false,
                    "poster_path": "/mhDdx7o7hhrxrikq8aqPLLnS9w8.jpg",
                    "id": 475430,
                    "adult": false,
                    "backdrop_path": "/o0F8xAt8YuEm5mEZviX5pEFC12y.jpg",
                    "original_language": "en",
                    "original_title": "Artemis Fowl",
                    "genre_ids": [
                        12,
                        14,
                        878,
                        10751
                    ],
                    "title": "Artemis Fowl",
                    "vote_average": 6,
                    "overview": "Artemis Fowl is a 12-year-old ...",
                    "release_date": "2020-06-12"
                },
                {
                    "popularity": 250.576,
                    "vote_count": 10,
                    "video": false,
                    "poster_path": "/1Duc3EBiegywczxTWekvy03HWai.jpg",
                    "id": 554993,
                    "adult": false,
                    "backdrop_path": "/oCFbh4Mrd0fuGanCgIF6sG27WGD.jpg",
                    "original_language": "sv",
                    "original_title": "Britt-Marie var här",
                    "genre_ids": [
                        35,
                        18
                    ],
                    "title": "Britt-Marie Was Here",
                    "vote_average": 4.5,
                    "overview": "Britt-Marie, a woman in her sixties ...",
                    "release_date": "2019-01-25"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.movieListModel = try! decoder.decode(MovieListModel.self, from: jsonData)
    }
    
    func testMovieListModelToReturnExpectedPageNumber() {
        XCTAssertEqual(self.movieListModel.page, 1)
    }
    
    func testMovieListModelToReturnExpectedNoOfTotalPages() {
        XCTAssertEqual(self.movieListModel.totalPages, 1)
    }
    
    func testMovieListModelToReturnExpectedNumberOfTotalResultsForThePage() {
        XCTAssertEqual(self.movieListModel.totalResults, 2)
    }
    
    func testMovieListModelToReturnExpectedMovieDetails() {
        let movie = self.movieListModel.results[0]
        
        XCTAssertEqual(movie.id, 475430)
        XCTAssertEqual(movie.title, "Artemis Fowl")
        XCTAssertEqual(movie.overview, "Artemis Fowl is a 12-year-old ...")
        XCTAssertEqual(movie.posterPath, "/mhDdx7o7hhrxrikq8aqPLLnS9w8.jpg")
        XCTAssertEqual(movie.releaseDate, "2020-06-12")
        XCTAssertEqual(movie.voteAverage, 6.0)
    }
}
