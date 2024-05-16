//
//  DiscoveryCollectionViewCell.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class DiscoveryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        // Initialization code
    }
    
    func setImageUrl(_ path: String?) {
        if let path, let imageURL = URL(string: Constants.BASE_IMAGE_URL + path) {
            imageView.load(from: imageURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
