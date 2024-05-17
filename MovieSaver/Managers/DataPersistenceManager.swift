//
//  DataPersistenceManager.swift
//  MovieSaver
//
//  Created by tungdd on 17/05/2024.
//

import CoreData
import UIKit

enum DatabaseError: Error {
    case failedToSaveData
    case failedToFetchData
}

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    private init() {}

    func save(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.newBackgroundContext()

        let item = MovieItem(context: context)
        item.id = Int64(model.id)

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }

    func fetch(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()

        do {
            let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }

    func delete(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.newBackgroundContext()
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let movies = try context.fetch(request)

            if let movie = movies.first {
                context.delete(movie)
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
}
