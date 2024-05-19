//
//  ExploreViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

protocol ExploreDelegate: AnyObject {
    func didUpdateMovies()
    func didSelectCategory()
}

class ExploreViewModel {
    weak var delegate: ExploreDelegate?

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCategory), name: .didSelectCategory, object: nil)
    }

    private var movies = [Movie]() {
        didSet {
            if let delegate {
                delegate.didUpdateMovies()
            }
        }
    }
    
    private var currentCategoryId: Int? {
        didSet {
            fetchMovies(id: currentCategoryId)
        }
    }

    private var isLoading = false
    private var page = 1

    func numberOfMovies() -> Int {
        return movies.count
    }

    func fetchMovies(id: Int?) {
        guard let id else { return }
        NetworkManager.shared.getMoviesByGenre(id: id, page: page, completion: {
            [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.movies += response.results
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func refresh() {
        page = 1
        fetchMovies(id: currentCategoryId)
    }

    func fetchMore() {
        page += 1
        fetchMovies(id: currentCategoryId)
    }

    func getMovie(index: Int) -> Movie? {
        if index >= movies.count {
            return nil
        }
        return movies[index]
    }

    @objc func didSelectCategory(notification: NSNotification) {
        if let id = notification.object as? Int {
            page = 1
            movies = []
            currentCategoryId = id
            delegate?.didSelectCategory()
        }
    }
}
