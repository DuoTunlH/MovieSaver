//
//  Movie.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

class Movie: Codable {
    var id: Int
    var original_language: String?
    var title: String?
    var original_title: String?
    var overview: String?
    var popularity: Double
    var poster_path: String?
    var release_date: String?
    var vote_count: Int?
}

class MoviesResponse: Codable {
    let results: [Movie]
}

class MovieResponse: Codable {
    let result: Movie
}
