//
//  MovieListViewController.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import UIKit

protocol MovieListViewControllerProtocol: class {}

class MovieListViewController: UIViewController {
    @IBOutlet weak var movieListTableView: UITableView!

    private let presenter: MovieListPresenterProtocol

    init() {
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter(interactor: interactor)
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        interactor.presenter = presenter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }

    private func setupTableView() {
        self.movieListTableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.reuseIndentifier)
        self.movieListTableView.dataSource = self
        self.movieListTableView.delegate = self
        self.movieListTableView.estimatedRowHeight = 76.0
        self.movieListTableView.rowHeight = UITableView.automaticDimension
        self.movieListTableView.reloadData()
    }
}


//MARK: TableView Methods
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Replace this with count of movies
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Update cell data
        return tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIndentifier, for: indexPath)
    }
}

extension MovieListViewController: UITableViewDelegate {
    //TODO: Implement didSelect for TableView row
}

//MARK: MovieListProtocol methods
extension MovieListViewController: MovieListViewControllerProtocol {}
