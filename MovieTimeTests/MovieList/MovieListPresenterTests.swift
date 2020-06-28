//
//  MovieListPresenterTests.swift
//  MovieTimeTests
//
//  Created by Anshul Vyas on 28/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import XCTest
@testable import MovieTime

class MovieListPresenterTests: XCTestCase {
    var presenter: MovieListPresenter!
    let interactorMock: MovieListInteractorMock = MovieListInteractorMock()
    let routerMock: MovieListRouterMok = MovieListRouterMok()
    let viewMock: MovieListViewMock = MovieListViewMock()
    
    override func setUpWithError() throws {
        self.presenter = MovieListPresenter(interactor: self.interactorMock, router: self.routerMock)
        self.presenter.view = viewMock
    }
    
    func testViewDidLoadTellsViewToStartLoading() {
        self.presenter.viewDidLoad()
        XCTAssertTrue(self.viewMock.startLoadingCalled)
    }
    
    func testViewDidLoadTellsInteractorToStartFetchingMovies() {
        self.presenter.viewDidLoad()
        XCTAssertTrue(self.interactorMock.fetchMovieListCalled)
    }
    
    func testGetNumberOfRowsToReturnExpectedNumbersOfRows() {
        let successData = self.setPresenterToSuccess()
        XCTAssertEqual(self.presenter.getNumberOfRows(), successData.results.count)
    }
    
    func testGetCellDataToReturnCellDataBasedOnIndex() {
        let successData = self.setPresenterToSuccess()
        let movieData = successData.results[0]
        let cellData = MovieCellData(imageUrl: movieData.posterPath, title: movieData.title, description: movieData.overview, releaseData: movieData.releaseDate, votes: movieData.voteAverage)
        
        XCTAssertEqual(self.presenter.getCellData(at: 0), cellData)
    }
    
    func testFetchMovieListSuccessToTellViewToStopLoading() {
        self.setPresenterToSuccess()
        XCTAssertTrue(self.viewMock.stopLoadingCalled)
    }
    
    func testFetchMovieListSuccessToTellViewToReloadData() {
        self.setPresenterToSuccess()
        XCTAssertTrue(self.viewMock.reloadDataCalled)
    }
    
    func testFetchMovieListFailureToTellViewToStopLoading() {
        self.setPresenterToFailure()
        XCTAssertTrue(self.viewMock.stopLoadingCalled)
    }
    
    func testFetchMovieListFailureToTellViewToShowErrorPopup() {
        self.setPresenterToFailure()
        
        XCTAssertEqual(self.viewMock.showErrorPopUpCalledWithArgs?.title, "error_popup_title".localizedString())
        XCTAssertEqual(self.viewMock.showErrorPopUpCalledWithArgs?.message, "error_popup_message".localizedString())
    }
    
    //MARK: Mocks
    class MovieListInteractorMock: MovieListInteractorProtocol {
        var fetchMovieListCalled: Bool = false
        func fetchMovieList() {
            self.fetchMovieListCalled = true
        }
    }
    
    class MovieListRouterMok: MovieListRouterProtocol {
        //TODO: Get Rid of UIKit element UIViewController
        static func createMovieListModule(appDelegate: AppDelegateProtocol) -> UIViewController {
            return UIViewController()
        }
    }
    
    class MovieListViewMock: MovieListViewControllerProtocol {
        var startLoadingCalled: Bool = false
        func startLoading() {
            self.startLoadingCalled = true
        }
        
        var stopLoadingCalled: Bool = false
        func stopLoading() {
            self.stopLoadingCalled = true
        }
        
        var reloadDataCalled: Bool = false
        func reloadData() {
            self.reloadDataCalled = true
        }
        
        var showErrorPopUpCalledWithArgs: (title: String, message: String)?
        func showErrorPopUp(title: String, message: String) {
            self.showErrorPopUpCalledWithArgs = (title: title, message: message)
        }
    }
    
    //MARK: Helpers
    @discardableResult private func setPresenterToSuccess() -> MovieListModel {
        let movies: [MovieListModel.Movie] = [
            MovieListModel.Movie(id: 1, title: "Title 1", overview: "Overview 1", posterPath: "Poster Path 1", releaseDate: "20-10-2020", voteAverage: 5.0),
            MovieListModel.Movie(id: 2, title: "Title 2", overview: "Overview 2", posterPath: "Poster Path 2", releaseDate: "10-10-2020", voteAverage: 6.0),
        ]
        
        let data = MovieListModel(page: 1, totalResults: 2, totalPages: 1, results: movies)
        self.presenter.fetchMovieListSuccess(data: data)
        
        return data
    }
    
    @discardableResult private func setPresenterToFailure() -> HTTPError {
        let error = HTTPError.serverSideError(500)
        self.presenter.fetchMovieListError(error: error)
        return error
    }
}

//MARK: Equatable Extension
extension MovieCellData: Equatable {
    public static func == (lhs: MovieCellData, rhs: MovieCellData) -> Bool {
        return lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.releaseData == rhs.releaseData &&
            lhs.votes == rhs.votes
    }
}
