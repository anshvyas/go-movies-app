//
//  UIImageExtension.swift
//  GoMovies
//
//  Created by Anshul Vyas on 15/06/20.
//  Copyright © 2020 Anshul Vyas. All rights reserved.
//

import Foundation
import UIKit

let imageDownloader: ImageDownloader = ImageDownloader()

extension UIImageView {

    private struct AssociatedKey {
        static var movieImageUrl: String = "movie_image_url"
    }

    final private var imageUrl: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.movieImageUrl) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.movieImageUrl, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func setImage(urlString: String, placeHolderImage: String, loadingImage: String) {
        self.imageUrl = urlString
        self.image = UIImage(named: loadingImage)
        imageDownloader.download(urlString: urlString) {[weak self] (result) in
            guard let self = self, self.imageUrl == urlString else {
                return
            }

            switch result {
            case .success(let data):
                self.image = UIImage(data: data)
                self.layoutIfNeeded()
            case .failure:
                self.image = UIImage(named: placeHolderImage)
                self.layoutIfNeeded()
            }
        }
    }
}
