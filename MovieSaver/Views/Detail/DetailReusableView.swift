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
    @IBOutlet var similarLabel: UILabel!
    
    @IBOutlet weak var webViewPlaceholder: UIView! // Outlet for the placeholder view
    
    var webView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        similarLabel.text = "similar".localize()
        
        if #available(iOS 13.0, *) {
              let wkWebView = WKWebView(frame: webViewPlaceholder.bounds)
              webView = wkWebView
          } else {
              let uiWebView = UIWebView(frame: webViewPlaceholder.bounds)
              webView = uiWebView
          }
        
        if let webView = webView {
            webView.translatesAutoresizingMaskIntoConstraints = false

            webViewPlaceholder.addSubview(webView)

            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: webViewPlaceholder.topAnchor),
                webView.bottomAnchor.constraint(equalTo: webViewPlaceholder.bottomAnchor),
                webView.leadingAnchor.constraint(equalTo: webViewPlaceholder.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: webViewPlaceholder.trailingAnchor)
            ])
         }
    }
    
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
        guard let path = trailer.key, let url = URL(string: "https://www.youtube.com/embed/\(path)") else { return }
        
        if #available(iOS 13.0, *) {
            if let webView = webView as? WKWebView {
                webView.load(URLRequest(url: url))
            }
          } else {
              if let webView = webView as? UIWebView {
                  webView.loadRequest(URLRequest(url: url))
              }
          }
    }
}
