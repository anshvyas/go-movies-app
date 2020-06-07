//
//  MovieTableViewCell.swift
//  GoMovies
//
//  Created by Anshul Vyas on 06/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieVotesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
    }

    private func initialSetup() {
        self.movieTitleLabel.text = ""
        self.movieDescriptionLabel.text = ""
        self.movieReleaseDateLabel.text = ""
        self.movieVotesLabel.text = ""
    }

    func updateData(data: MovieCellData) {
        //TODO: Download Appropriate Movie Image
        self.movieImageView.image = UIImage(named: "DefaultPoster")
        self.movieTitleLabel.text = data.title
        self.movieDescriptionLabel.text = data.description
        self.movieReleaseDateLabel.text = data.releaseData
        self.movieVotesLabel.text = "Rating: \(data.votes.description)"
    }
}

extension MovieTableViewCell {
    static var reuseIndentifier: String { return "MovieTableViewCell" }
    static var nib: UINib { return UINib(nibName: "MovieTableViewCell", bundle: nil) }
}

struct MovieCellData {
    let imageUrl: String
    let title: String
    let description: String
    let releaseData: String
    let votes: Double
}
