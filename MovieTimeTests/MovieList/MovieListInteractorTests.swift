//
//  MovieListInteractorTests.swift
//  MovieTimeTests
//
//  Created by Anshul Vyas on 21/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import XCTest
@testable import MovieTime

class MovieListInteractorTests: XCTestCase {
    var interactor: MovieListInteractor!
    let networkServiceMock: MovieNetworkServiceMock = MovieNetworkServiceMock()
    let presenterMock: MovieListPresenterMock = MovieListPresenterMock()

    override func setUpWithError() throws {
        self.interactor = MovieListInteractor(service: self.networkServiceMock)
        self.interactor.presenter = self.presenterMock
    }

    func testFetchMovieListToStartAPICallWithAppropriateAPIData() {
        self.interactor.fetchMovieList(page: 1)
        self.setupSuccessStata()

        XCTAssertEqual(self.networkServiceMock.apiData?.requestType, .get)
        XCTAssertEqual(self.networkServiceMock.apiData?.urlString, Constants.movieListUrlString)
        XCTAssertNotNil(self.networkServiceMock.completionHandler)
    }

    func testFetchMovieListSuccessCallsSuccessDelegateOfPresenterWithResponseModel() {
        self.interactor.fetchMovieList(page: 1)
        let model = self.setupSuccessStata()

        XCTAssertEqual(self.presenterMock.fetchMovieListSuccessCalledWithData?.results.count, model.results.count)
        XCTAssertEqual(self.presenterMock.fetchMovieListSuccessCalledWithData?.totalResults, model.totalResults)
        XCTAssertEqual(self.presenterMock.fetchMovieListSuccessCalledWithData?.totalPages, model.totalPages)
    }

    func testFetchMovieListFailureCallsFailureDelegateOfPresenterWithServerError() {
        self.interactor.fetchMovieList(page: 1)
        let error = self.setupServerErrorState()

        XCTAssertEqual(self.presenterMock.fetchMovieListErrorCalledWithError, error)
    }

    func testFetchMovieListWithEmptyDataCallsFailureDelegateOfPresenterWithEmptyDataError() {
        self.interactor.fetchMovieList(page: 1)
        self.setupEmptyDataStata()

        XCTAssertEqual(self.presenterMock.fetchMovieListErrorCalledWithError, .responseParsingError(reason: .emptyData))
    }

    func testFetchMovieListWithCorruptDataCallsFailureDelegateOfPresenterWithJSONParsingError() {
        self.interactor.fetchMovieList(page: 1)
        self.setupCorruptDataStata()

        XCTAssertEqual(self.presenterMock.fetchMovieListErrorCalledWithError, .responseParsingError(reason: .jsonParsingFailed))
    }

    //MARK: Mock
    class MovieListPresenterMock: MovieListIneractorDelegate {
        var fetchMovieListSuccessCalledWithData: MovieListModel?
        func fetchMovieListSuccess(data: MovieListModel) {
            self.fetchMovieListSuccessCalledWithData = data
        }

        var fetchMovieListErrorCalledWithError: HTTPError?
        func fetchMovieListError(error: HTTPError) {
            self.fetchMovieListErrorCalledWithError = error
        }
    }

    //MARK: Helpers
    @discardableResult private func setupSuccessStata() -> MovieListModel {
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
                    "overview": "Artemis Fowl is a 12-year-old genius and descendant of a long line of criminal masterminds. He soon finds himself in an epic battle against a race of powerful underground fairies who may be behind his father's disappearance.",
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
                    "overview": "Britt-Marie, a woman in her sixties, decides to leave her husband and start anew. Having been housewife for most of her life and and living in small backwater town of Borg, there isn't many jobs available and soon she finds herself fending a youth football team.",
                    "release_date": "2019-01-25"
                }
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let model = try! decoder.decode(MovieListModel.self, from: jsonData)
        self.networkServiceMock.completionHandler!(.success(jsonData))

        return model
    }

    @discardableResult private func setupServerErrorState() -> HTTPError {
        let error: HTTPError = .serverSideError(500)
        self.networkServiceMock.completionHandler!(.failure(error))

        return error
    }

    private func setupEmptyDataStata() {
        self.networkServiceMock.completionHandler!(.success(nil))
    }

    private func setupCorruptDataStata() {
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
            ]
        }
        """.data(using: .utf8)!
        self.networkServiceMock.completionHandler!(.success(jsonData))
    }
}

extension HTTPError: Equatable {
    public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.imageDownloadingError, .imageDownloadingError):
            return true
        case (.serverSideError(let lhsStatusCode), .serverSideError(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.responseParsingError(let lhsReason), .responseParsingError(let rhsReason)):
            return lhsReason == rhsReason
        case (.urlParsingError, .urlParsingError):
            return true
        default:
            return false
        }
    }
}
