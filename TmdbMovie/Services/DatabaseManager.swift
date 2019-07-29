//
//  DatabaseManager.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum DataType {
    case movie(data: Movie)
    
    var entityDescription: String {
        switch self {
        case .movie:
            return "Movies"
        }
    }
}

protocol DatabaseHandler {
    var context: NSManagedObjectContext? { get }
    func database(_ handler: DatabaseHandler, willSaveData data: DataType)
    func database(_ handler: DatabaseHandler, willRetrieveData data: DataType)
}

class DatabaseManager: DatabaseHandler {

    var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func database(_ handler: DatabaseHandler, willRetrieveData data: DataType) {
        guard let context = context else { return }
        
    }
    
    func database(_ handler: DatabaseHandler, willSaveData data: DataType) {
        guard let context = context else { return }
        let entity = NSEntityDescription.entity(forEntityName: data.entityDescription, in: context)
        switch data {
        case .movie(let movie):
            let newMovie = NSManagedObject(entity: entity!, insertInto: context)
            newMovie.setValue(movie.id, forKey: "id")
            newMovie.setValue(movie.overview, forKey: "overview")
            newMovie.setValue(movie.originalTitle, forKey: "original_title")
            newMovie.setValue(movie.releaseDate, forKey: "release_date")
            newMovie.setValue(movie.voteAverage, forKey: "vote_average")
            newMovie.setValue(movie.posterPath, forKey: "poster_path")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
}
