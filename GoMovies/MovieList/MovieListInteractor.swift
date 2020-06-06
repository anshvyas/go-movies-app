//
//  MovieListInteractor.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol MovieListInteractorProtocol: class {}

class MovieListInteractor {
    weak var presenter: MovieListPresenterProtocol?
}

//MARK: MovieListInteractorProtocol Methods
extension MovieListInteractor: MovieListInteractorProtocol {}
