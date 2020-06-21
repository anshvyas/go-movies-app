//
//  AppDelegate.swift
//  MovieTime
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import UIKit

protocol AppDelegateProtocol {
    var networkService: NetworkServiceProtocol { get }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController: UIViewController = MovieListRouter.createMovieListModule(appDelegate: self)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}

//MARK: AppDelegateProtocol
extension AppDelegate: AppDelegateProtocol {
    var networkService: NetworkServiceProtocol {
        return MovieNetworkService()
    }
}
