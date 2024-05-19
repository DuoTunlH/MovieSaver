//
//  SearchViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 19/05/2024.
//

import Foundation

protocol SearchDelegate: AnyObject {
    func didUpdateMovies()
}

class SearchViewModel {
    weak var delegate: SearchDelegate?
    
    private var movies = [Movie]() {
        didSet {
            delegate?.didUpdateMovies()
        }
    }
    
    private var searchText: String?
    
    func search(searchText: String) {
        
        movies = []
        
        NetworkManager.shared.searchMovies(text: searchText, page: 1) { results in
            switch results {
            case .success(let response):
                self.movies = response.results
            case let .failure(error):
                print(error)
            }
        }
    }
      
    func resetSearch() {
        movies = []
    }
    
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    func getMovie(index: Int) -> Movie? {
        if index >= movies.count {
            return nil
        }
        return movies[index]
    }
}
