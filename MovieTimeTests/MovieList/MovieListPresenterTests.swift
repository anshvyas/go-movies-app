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
    private var presenter: MovieListPresenter!
    private let interactorMock: MovieListInteractorMock = MovieListInteractorMock()
    private let routerMock: MovieListRouterMok = MovieListRouterMok()
    private let viewMock: MovieListViewMock = MovieListViewMock()
    private let timerMock: TimerMock = TimerMock()
    
    override func setUpWithError() throws {
        self.presenter = MovieListPresenter(interactor: self.interactorMock, router: self.routerMock, timerType: TimerMock.self)
        TimerMock.timerMock = self.timerMock
        self.presenter.view = viewMock
    }
    
    func testViewDidLoadTellsViewToStartLoading() {
        self.presenter.viewDidLoad(page: 1)
        XCTAssertTrue(self.viewMock.startLoadingCalled)
    }
    
    func testViewDidLoadTellsInteractorToStartFetchingMoviesForRequestedPage() {
        self.presenter.viewDidLoad(page: 1)
        XCTAssertEqual(self.interactorMock.fetchMovieListCalledWithPage, 1)
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
        XCTAssertTrue(self.viewMock.showMovieListCalled)
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
    
    func testRefreshMovieListToInvalidatesPreviousTimer() {
        self.presenter.refreshMovieList(page: 2)
        self.presenter.refreshMovieList(page: 3)
        
        XCTAssertTrue(self.timerMock.invalidateCalled)
    }
    
    func testRefreshMovieListToFiresTimerToStartFetchingMoviesForRequestedPage() {
        self.presenter.refreshMovieList(page: 2)
        
        XCTAssertEqual(self.interactorMock.fetchMovieListCalledWithPage, 2)
    }
    
    func testRefreshMovieListFiresTimerToHideMovieList() {
        self.presenter.refreshMovieList(page: 2)
        
        XCTAssertTrue(self.viewMock.hideMovieListCalled)
    }
    
    func testRefreshMovieListFiresTimerToStartLoading() {
        self.presenter.refreshMovieList(page: 2)
        
        XCTAssertTrue(self.viewMock.startLoadingCalled)
    }
    
    //MARK: Mocks
    class MovieListInteractorMock: MovieListInteractorProtocol {
        var fetchMovieListCalledWithPage: Int?
        func fetchMovieList(page: Int) {
            self.fetchMovieListCalledWithPage = page
        }
    }
    
    class MovieListRouterMok: MovieListRouterProtocol {
        //TODO: Get Rid of UIKit element UIViewController
        static func createMovieListModule(appDelegate: AppDelegateProtocol) -> UIViewController {
            return UIViewController()
        }
    }
    
    class MovieListViewMock: MovieListViewControllerProtocol {
        var hideMovieListCalled: Bool = false
        func hideMovieList() {
            self.hideMovieListCalled = true
        }
        
        var showMovieListCalled: Bool = false
        func showMovieList() {
            self.showMovieListCalled = true
        }
        
        var startLoadingCalled: Bool = false
        func startLoading() {
            self.startLoadingCalled = true
        }
        
        var stopLoadingCalled: Bool = false
        func stopLoading() {
            self.stopLoadingCalled = true
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
