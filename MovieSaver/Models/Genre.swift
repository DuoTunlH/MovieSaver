//
//  Genre.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

class Genre: Codable {
    var id: Int
    var name: String
}

class GenresResponse: Codable {
    let genres: [Genre]
}
