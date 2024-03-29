//
//  MovieController.swift
//  TmdbMovie
//
//  Created by Michael Abadi Santoso on 7/29/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation
import CoreData

/// Purpose of this class for making specific request on movie list such as set favorite
final class MovieDatabaseManager: DatabaseManager {
    
    func makeModel() -> [MovieModel] {
        guard let context = context else { return [] }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.returnsObjectsAsFaults = false
        var models: [MovieModel] = []
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as? NSNumber ?? 0
                let title = data.value(forKey: "original_title") as? String ?? ""
                let overview = data.value(forKey: "overview") as? String ?? ""
                let rating = data.value(forKey: "vote_average") as? NSNumber ?? 0
                let releaseDate = data.value(forKey: "release_date") as? String ?? ""
                let isFavorite = data.value(forKey: "isFavorite") as? Bool ?? false
                let posterPath = data.value(forKey: "poster_path") as? String ?? ""
                let thumbnail = URL(string: "\(TmdbConfig.imageBaseUrl)\(posterPath)")
                let model = MovieModel(id: Int(truncating: id), thumbnail: thumbnail, title: title, synopsis: overview, rating: Int(truncating: rating), releaseDate: releaseDate, isFavorite: isFavorite)
                models.append(model)
            }
            return models
        } catch {
            print("Failed")
        }
        return []
    }
    
    func setFavorite(_ id: Int) {
        guard let context = context else { return }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let favorite = data.value(forKey: "isFavorite") as? Bool ?? false
                data.setValue(!favorite, forKey: "isFavorite")
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }
    
    func saveResponse(_ response: [String: Any]) {
        guard let results = response["results"] as? [[String: Any]] else { return }
        for item in results {
            let movie = Movie(response: item)
            database(self, willSaveData: .movie(data: movie))
        }
    }
    
    func favoriteStatus(forMovieId id: Int) -> Bool {
        guard let context = context else { return false }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movies")
        request.predicate = NSPredicate(format: "id = %d", id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let favorite = data.value(forKey: "isFavorite") as? Bool ?? false
                return favorite
            }
        } catch {
            print("Failed")
        }
        return false
    }
    
}

protocol MovieControllerDelegate: AnyObject {
    func movieController(_ controller: MovieController, withModel model: [MovieModel])
}

/// Class for control data flow in the movie modules
final class MovieController: BaseController {
    
    private let databaseManager: MovieDatabaseManager = MovieDatabaseManager()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(observer: self)
    }()
    
    weak var delegate: MovieControllerDelegate?
    
    var isLoading: Bool = false
    
    var page: Int = 1 {
        didSet {
            loadData(withPage: page)
        }
    }
    
    var sortType: MovieListRequest.SortType = .popularity {
        didSet {
            models = []
            page = 1
            loadData(withPage: page)
        }
    }
    
    var models: [MovieModel] = []
    
    func loadData(withPage page: Int) {
        if page == 1 {
            models = []
        }
        guard !isLoading else { return }
        isLoading = true
        let request = MovieListRequest(sortBy: sortType, pages: page)
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.networkManager.network(strongSelf, willSendRequest: request, method: .get)
        }
    }
    
}

// MARK: NetworkManagerObserver
extension MovieController: NetworkManagerObserver {
    
    func networkManager(_ manager: NetworkManager?, didRetrieveDataWith response: Any) {
        isLoading = false
        guard let response = response as? [String: Any] else { return }
        guard let results = response["results"] as? [[String: Any]] else { return }
        for item in results {
            let movie = Movie(response: item)
            let favorite = databaseManager.favoriteStatus(forMovieId: movie.id ?? 0)
            let thumbnail = URL(string: "\(TmdbConfig.imageBaseUrl)\(movie.posterPath ?? "")")
            models.append(MovieModel(id: movie.id ?? 0, thumbnail: thumbnail, title: movie.originalTitle ?? "", synopsis: movie.overview ?? "", rating: Int(truncating: movie.voteAverage ?? 0), releaseDate: movie.releaseDate ?? "", isFavorite: favorite))
        }
        databaseManager.saveResponse(response)
        delegate?.movieController(self, withModel: models)
    }
    
}
