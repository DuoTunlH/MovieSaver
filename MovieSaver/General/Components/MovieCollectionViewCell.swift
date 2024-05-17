//
//  MovieCollectionViewCell.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        // Initialization code
    }

    func setupNode(movie: Movie) {
        if let path = movie.poster_path, let imageURL = URL(string: Constants.BASE_IMAGE_URL + path) {
            imageView.load(from: imageURL)
        }
        titleLabel.text = movie.title

        if let date = movie.release_date {
            if date != "" {
                let index = date.index(date.startIndex, offsetBy: 4)
                let substring = String(date.prefix(upTo: index))
                releaseDateLabel.text = substring
            }
        }
        overviewLabel.text = movie.overview
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
