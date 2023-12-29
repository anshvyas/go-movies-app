//
//  MovieListInteractor.swift
//  MovieTime
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation

protocol MovieListInteractorProtocol: AnyObject {
    func fetchMovieList(page: Int)
}

class MovieListInteractor {
    weak var presenter: MovieListIneractorDelegate?
    private let service: NetworkServiceProtocol

    init(service: NetworkServiceProtocol) {
        self.service = service
    }
}

//MARK: MovieListInteractorProtocol Methods
extension MovieListInteractor: MovieListInteractorProtocol {
    func fetchMovieList(page: Int) {
        self.service.cancelAPIRequest()
        
        let apiData = MovieListAPIData(bearerToken: Credentials.getBearerTokenHeaderValue(), contentType: Constants.contentType, page: page)

        self.service.makeAPIRequest(data: apiData) {[weak self] (result) in
            guard let self = self, let sPresenter = self.presenter else {
                return
            }

            switch result {
            case .success(let data):
                guard let aData = data as? Data else {
                    sPresenter.fetchMovieListError(error: .responseParsingError(reason: .emptyData))
                    return
                }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let data = try decoder.decode(MovieListModel.self, from: aData)
                    sPresenter.fetchMovieListSuccess(data: data)
                } catch {
                    sPresenter.fetchMovieListError(error: .responseParsingError(reason: .jsonParsingFailed))
                }

            case .failure(let error):
                sPresenter.fetchMovieListError(error: error)
            }
        }
    }
}
