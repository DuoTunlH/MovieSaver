//
//  ExploreViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation
 
protocol ExploreDelegate: AnyObject {
    func didUpdateMovies()
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
    
    func numberOfMovies() -> Int{
        return movies.count
    }
    
    func fetchMovies(id: Int) {
        NetworkManager.shared.getMoviesByGenre(id: id, completion: {
            result in
            switch result {
            case .success(let response):
                self.movies = response.results
            case .failure(let error):
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
    
    @objc func didSelectCategory(notification: NSNotification) {
        if let id = notification.object as? Int {
            fetchMovies(id: id)
        }
    }
}
