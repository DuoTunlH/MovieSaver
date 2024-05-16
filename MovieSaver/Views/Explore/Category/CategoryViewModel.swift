//
//  CategoryViewModel.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

protocol CategoryDelegate: AnyObject {
    func didUpdateCategory()
}

class CategoryViewModel {
    weak var delegate: CategoryDelegate?

    private var genres = [Genre]() {
        didSet {
            delegate?.didUpdateCategory()
        }
    }

    func numberOfGenres() -> Int {
        return genres.count
    }

    func getGenre(index: Int) -> Genre? {
        if index >= genres.count {
            return nil
        }
        return genres[index]
    }

    func fetchCategory() {
        NetworkManager.shared.getGenres(completion: {
            result in
            switch result {
            case let .success(response):
                self.genres = response.genres
                self.setSelectedCategory(index: 0)
            case let .failure(error):
                print(error)
            }
        })
    }

    func setSelectedCategory(index: Int) {
        if index >= genres.count {
            return
        }
        NotificationCenter.default.post(name: .didSelectCategory, object: genres[index].id)
    }
}
