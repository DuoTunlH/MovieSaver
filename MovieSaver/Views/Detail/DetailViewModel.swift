//
//  DetailViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

protocol DetailDelegate: AnyObject {
    func didUpdateSimilarMovies()
    func didUpdateTrailer()
    func didUpdateFavourite(isFavourite: Bool)
}

class DetailViewModel {
    weak var delegate: DetailDelegate?

    private var similarMovies = [Movie]() {
        didSet {
            delegate?.didUpdateSimilarMovies()
        }
    }

    private var trailers = [Video]() {
        didSet {
            delegate?.didUpdateTrailer()
        }
    }

    private var _isFavourite: Bool = false {
        didSet {
            delegate?.didUpdateFavourite(isFavourite: _isFavourite)
        }
    }

    func isFavourite() -> Bool {
        return _isFavourite
    }

    private var movie: Movie?

    func setMovie(_ movie: Movie) {
        self.movie = movie
    }

    func getMovie() -> Movie? {
        return movie
    }

    func fetchSimilarMovies() {
        guard let movie else { return }
        NetworkManager.shared.getSimilarMovies(id: movie.id, completion: {
            [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.similarMovies = response.results
                self.delegate?.didUpdateSimilarMovies()
            case let .failure(error):
                print(error)
            }
        })
    }

    func fetchTrailers() {
        guard let movie else { return }

        NetworkManager.shared.getMovieTrailer(id: movie.id, completion: {
            [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(response):
                self.trailers = response.results
                self.delegate?.didUpdateTrailer()
            case let .failure(error):
                print(error)
            }
        })
    }

    func fetchIsFavourite() {
        guard let movie else { return }

        DataPersistenceManager.shared.fetch(completion: {
            [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(movieItems):
                self._isFavourite = movieItems.contains { $0.id == movie.id }
            case let .failure(error):
                print(error)
            }
        })
    }

    func numberOfMovies() -> Int {
        return similarMovies.count
    }

    func toggleFavourite() {
        guard let movie = movie else { return }

        _isFavourite.toggle()

        if _isFavourite {
            DataPersistenceManager.shared.save(model: movie) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success:
                    NotificationCenter.default.post(name: .didAddFavourite, object: movie)
                case let .failure(error):
                    print(error)
                    self._isFavourite = false
                }
            }
        } else {
            DataPersistenceManager.shared.delete(id: movie.id) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .didRemoveFavourite, object: movie.id)
                case let .failure(error):
                    print(error)
                    self._isFavourite = true
                }
            }
        }
    }

    func getSimilarMovies(index: Int) -> Movie? {
        if index >= similarMovies.count {
            return nil
        }
        return similarMovies[index]
    }

    func getTrailer() -> Video? {
        return trailers.first { $0.type == "Trailer" }
    }
}
