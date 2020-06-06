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
        self.movieListTableView.dataSource = self
        self.movieListTableView.delegate = self
    }
}


//MARK: TableView Methods
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Replace this with count of movies
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Dequeue Custom TableViewCell
        return UITableViewCell(frame: .zero)
    }
}

extension MovieListViewController: UITableViewDelegate {
    //TODO: Implement didSelect for TableView row
}
