//
//  APIManager.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import Foundation

enum Constants {
    static let API_KEY = "f14dabb7ec91ad6abc33ee277d4c4d07"
    static let BASE_URL = "https://api.themoviedb.org"
    static let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w500/"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case requestFailed(Error)
    case invalidResponse
    case invalidStatusCode(Int)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = Constants.BASE_URL
    private let apiKey = Constants.API_KEY

    private init() {}

    func getGenres(completion: @escaping (Result<GenresResponse, NetworkError>) -> Void) {
        guard let url = buildURL(path: "/3/genre/movie/list") else {
            completion(.failure(.invalidURL))
            return
        }
        request(url: url, completion: completion)
    }
    
    func getDiscovery(completion: @escaping (Result<MoviesResponse, NetworkError>) -> Void) {
        guard let url = buildURL(path: "/3/discover/movie") else {
            completion(.failure(.invalidURL))
            return
        }
        request(url: url, completion: completion)
    }
    
    func getMoviesByGenre(id: Int, completion: @escaping (Result<MoviesResponse, NetworkError>) -> Void) {
        guard let url = buildURL(path: "/3/discover/movie", queryItems: [("with_genres", String(id))]) else {
            completion(.failure(.invalidURL))
            return
        }
        request(url: url, completion: completion)
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (Result<MoviesResponse, NetworkError>) -> Void) {
        guard let url = buildURL(path: "/3/movie/\(id)/similar") else {
            completion(.failure(.invalidURL))
            return
        }
        request(url: url, completion: completion)
    }

    private func request<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.invalidStatusCode(httpResponse.statusCode)))
                    return
                }

                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }

                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
            task.resume()
        }
    }
        

    private func buildURL(path: String, queryItems: [(String, String)]? = nil) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path

        var allQueryItems = [URLQueryItem(name: "api_key", value: apiKey)]

        if let additionalQueryItems = queryItems {
            allQueryItems += additionalQueryItems.map { URLQueryItem(name: $0.0, value: $0.1) }
        }

        components?.queryItems = allQueryItems
        return components?.url
    }
}
