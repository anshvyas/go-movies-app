//
//  MovieListPresenter.swift
//  MovieTime
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol MovieListIneractorDelegate: AnyObject {
    func fetchMovieListSuccess(data: MovieListModel)
    func fetchMovieListError(error: HTTPError)
}

protocol MovieListViewDelegate: AnyObject {
    func viewDidLoad(page: Int)
    func refreshMovieList(page: Int)
    func getNumberOfRows() -> Int
    func getCellData(at index: Int) -> MovieCellData
}

class MovieListPresenter {
    weak var view: MovieListViewControllerProtocol?
    private let interactor: MovieListInteractorProtocol
    private let router: MovieListRouterProtocol
    private var movies: [MovieListModel.Movie]
    private var debounceTimer: TimerProtocol?
    private let timerType: TimerProtocol.Type

    init(interactor: MovieListInteractorProtocol, router: MovieListRouterProtocol, timerType: TimerProtocol.Type = Timer.self) {
        self.interactor = interactor
        self.router = router
        self.movies = []
        self.timerType = timerType
    }
}

//MARK: Delegate callbacks for view
extension MovieListPresenter: MovieListViewDelegate {
    func viewDidLoad(page: Int) {
        self.view?.startLoading()
        self.view?.hideMovieList()
        self.interactor.fetchMovieList(page: page)
    }
    
    func refreshMovieList(page: Int) {
        self.debounceTimer?.invalidate()
        self.debounceTimer = self.timerType.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] (_) in
            guard let self else { return }
            self.view?.startLoading()
            self.view?.hideMovieList()
            self.interactor.fetchMovieList(page: page)
        }
    }

    func getNumberOfRows() -> Int {
        return self.movies.count
    }

    func getCellData(at index: Int) -> MovieCellData {
        let movieData = self.movies[index]

        return MovieCellData(
            imageUrl: movieData.posterPath,
            title: movieData.title,
            description: movieData.overview,
            releaseData: movieData.releaseDate,
            votes: movieData.voteAverage)
    }
}


//MARK: Delegate callbacks for Interactor
extension MovieListPresenter: MovieListIneractorDelegate {
    func fetchMovieListSuccess(data: MovieListModel) {
        self.movies = data.results
        self.view?.stopLoading()
        self.view?.showMovieList()
    }

    func fetchMovieListError(error: HTTPError) {
        self.view?.stopLoading()
        self.view?.showErrorPopUp(title: "error_popup_title".localizedString(), message: "error_popup_message".localizedString())
    }
}
