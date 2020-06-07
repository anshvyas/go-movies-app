//
//  MovieListPresenter.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol MovieListIneractorDelegate: class {
    func fetchMovieListSuccess(data: MovieListModel)
    func fetchMovieListError(error: HTTPError)
}

protocol MovieListViewDelegate: class {
    func viewDidLoad()
    func getNumberOfRows() -> Int
    func getCellData(at index: Int) -> MovieCellData
}

class MovieListPresenter {
    weak var view: MovieListViewControllerProtocol?
    private let interactor: MovieListInteractorProtocol
    private let router: MovieListRouterProtocol
    private var movies: [MovieListModel.Movie]

    init(interactor: MovieListInteractorProtocol, router: MovieListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.movies = []
    }
}

//MARK: Delegate callbacks for view
extension MovieListPresenter: MovieListViewDelegate {
    func viewDidLoad() {
        self.view?.startLoading()
        self.interactor.fetchMovieList()
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
        self.view?.reloadData()
    }

    func fetchMovieListError(error: HTTPError) {
        self.view?.stopLoading()
    }
}
