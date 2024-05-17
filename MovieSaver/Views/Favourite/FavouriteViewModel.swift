//
//  FavouriteViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 17/05/2024.
//

import Foundation

protocol FavouriteDelegate: AnyObject {
    func didUpdateMovies()
}

class FavouriteViewModel {
    weak var delegate: FavouriteDelegate?

    private var movies = [Movie]() {
        didSet {
            delegate?.didUpdateMovies()
        }
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didAddFavourite), name: .didAddFavourite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFavourite), name: .didRemoveFavourite, object: nil)
    }

    func fetchFavourite() {
        DataPersistenceManager.shared.fetch(completion: {
            result in
            switch result {
            case let .success(movies):
                let dispatchGroup = DispatchGroup()
                var fetchedMovies: [Movie] = []

                for movie in movies {
                    dispatchGroup.enter()
                    NetworkManager.shared.getMovieById(id: movie.id) { result in
                        switch result {
                        case let .success(response):
                            fetchedMovies.append(response)
                        case let .failure(error):
                            print(error)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .global()) {
                    self.movies = fetchedMovies
                }
            case let .failure(error):
                print(error)
            }
        })
    }

    @objc func didAddFavourite(notification: NSNotification) {
        guard let movie = notification.object as? Movie else { return }

        movies.insert(movie, at: 0)
    }

    @objc func didRemoveFavourite(notification: NSNotification) {
        guard let movieId = notification.object as? Int64 else { return }
        movies = movies.filter { $0.id != movieId }
    }

    func getMovie(index: Int) -> Movie? {
        if index >= movies.count {
            return nil
        }
        return movies[index]
    }

    func numberOfMovies() -> Int {
        return movies.count
    }
}
