//
//  DetailReusableView.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit
import WebKit

class DetailReusableView: UICollectionReusableView {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var videoWebView: WKWebView!

    func setMovie(_ movie: Movie) {
        titleLabel.text = movie.title ?? movie.original_title
        descriptionLabel.text = movie.overview
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        if let date = movie.release_date {
            if date != "" {
                let index = date.index(date.startIndex, offsetBy: 4)
                let substring = String(date.prefix(upTo: index))
                yearLabel.text = substring
            }
        }
    }

    func setTrailer(_ trailer: Video) {
        if let path = trailer.key, let url = URL(string: "https://www.youtube.com/embed/\(path)") {
            videoWebView.load(URLRequest(url: url))
        }
    }
}
