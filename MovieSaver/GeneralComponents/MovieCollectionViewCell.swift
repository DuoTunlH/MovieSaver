//
//  MovieCollectionViewCell.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
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
        releaseDateLabel.text = movie.release_date
        overviewLabel.text = movie.overview
        
    }

}