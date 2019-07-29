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
        return persistentContainer.viewContext
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
        
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TmdbMovie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
