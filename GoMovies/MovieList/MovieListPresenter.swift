//
//  MovieListPresenter.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol MovieListPresenterProtocol: class {}

class MovieListPresenter {
    weak var view: MovieListViewControllerProtocol?
    private let interactor: MovieListInteractorProtocol

    init(interactor: MovieListInteractorProtocol) {
        self.interactor = interactor
    }
}

//MARK: MovieListPresenterProtocol Methods
extension MovieListPresenter: MovieListPresenterProtocol {}
