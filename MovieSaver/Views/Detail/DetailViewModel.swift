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
            result in
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
            result in
            switch result {
            case let .success(response):
                self.trailers = response.results
                self.delegate?.didUpdateTrailer()
            case let .failure(error):
                print(error)
            }
        })
    }

    func numberOfMovies() -> Int {
        return similarMovies.count
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
