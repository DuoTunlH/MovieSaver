//
//  DiscoveryViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

protocol DiscoveryDelegate: AnyObject {
    func didUpdateMovies()
}

class DiscoveryViewModel {
    weak var delegate: DiscoveryDelegate?

    private var movies = [Movie]() {
        didSet {
            if let delegate {
                delegate.didUpdateMovies()
            }
        }
    }

    func fetchMovies() {
        NetworkManager.shared.getDiscovery(completion: {
            result in
            switch result {
            case let .success(response):
                self.movies = response.results
            case let .failure(error):
                print(error)
            }
        })
    }

    func getMovie(index: Int) -> Movie? {
        if index >= movies.count {
            return nil
        }
        return movies[index]
    }

    func selectCategory(index _: Int) {}
}
