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
    private var page: Int = 1
    
    func search(searchText: String) {
        
        movies = []
        page = 1
        self.searchText = searchText
        
        NetworkManager.shared.searchMovies(text: searchText, page: page) { results in
            switch results {
            case .success(let response):
                self.movies = response.results
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchMore() {
        guard let searchText else { return }
        
        page += 1
        
        NetworkManager.shared.searchMovies(text: searchText, page: page) { results in
            switch results {
            case .success(let response):
                self.movies += response.results
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
