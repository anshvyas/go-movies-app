//
//  MovieListRouter.swift
//  MovieTime
//
//  Created by Anshul Vyas on 07/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListRouterProtocol {
  static func createMovieListModule(appDelegate: AppDelegateProtocol) -> UIViewController
}

class MovieListRouter: MovieListRouterProtocol {
    weak var navigationController:UINavigationController?
    
    static func createMovieListModule(appDelegate: AppDelegateProtocol) -> UIViewController {
        let router = MovieListRouter()
        let interactor = MovieListInteractor(service: appDelegate.networkService)
        let presenter = MovieListPresenter(interactor: interactor, router: router)
        let view = MovieListViewController(presenter: presenter)
        let navVC = UINavigationController(rootViewController: view)
        presenter.view = view
        interactor.presenter = presenter
        router.navigationController = navVC

        return navVC
    }
}
