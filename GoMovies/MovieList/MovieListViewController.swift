//
//  MovieListViewController.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet weak var movieListTableView: UITableView!
    
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
