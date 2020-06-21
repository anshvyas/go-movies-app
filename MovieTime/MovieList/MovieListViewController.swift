//
//  MovieListViewController.swift
//  MovieTime
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import UIKit

protocol MovieListViewControllerProtocol: class {
    func startLoading()
    func stopLoading()
    func reloadData()
    func showErrorPopUp(title: String, message: String)
}

class MovieListViewController: UIViewController {
    @IBOutlet weak var movieListTableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView?

    private let presenter: MovieListViewDelegate

    init(presenter: MovieListViewDelegate) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.presenter.viewDidLoad()
    }

    private func setupActivityIndicator() -> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        return activityIndicator
    }

    private func setupTableView() {
        self.movieListTableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.reuseIndentifier)
        self.movieListTableView.dataSource = self
        self.movieListTableView.delegate = self
        self.movieListTableView.estimatedRowHeight = 76.0
        self.movieListTableView.rowHeight = UITableView.automaticDimension
        self.movieListTableView.isHidden = true
    }
}


//MARK: TableView Methods
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIndentifier, for: indexPath) as! MovieTableViewCell
        let cellData = self.presenter.getCellData(at: indexPath.row)
        cell.updateData(data: cellData)

        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    //TODO: Implement didSelect for TableView row
}

//MARK: MovieListProtocol methods
extension MovieListViewController: MovieListViewControllerProtocol {
    func showErrorPopUp(title: String, message: String) {
        let errorPopup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title:"error_popup_cta_title".localizedString(), style: .default, handler: { [weak self] (action) in
            self?.presenter.viewDidLoad()
        })
        errorPopup.addAction(retryAction)

        self.present(errorPopup, animated: true, completion: nil)
    }
    
    func startLoading() {
        let activityIndicator = self.setupActivityIndicator()
        self.activityIndicator = activityIndicator
        self.activityIndicator?.startAnimating()
    }
    
    func stopLoading() {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator? .removeFromSuperview()
        self.activityIndicator = nil
    }

    func reloadData() {
        self.movieListTableView.reloadData()
        self.movieListTableView.isHidden = false
    }
}
