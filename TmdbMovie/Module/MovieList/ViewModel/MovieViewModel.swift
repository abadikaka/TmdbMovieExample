//
//  MovieViewModel.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation

enum MovieContentItem {
    case loading
    case movie([MovieModel])
}

protocol MovieViewModelDatasource {
    var currentSortType: MovieListRequest.SortType { get }
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    func itemAt(_ indexPath: IndexPath) -> MovieContentItem
    func section(at indexPath: IndexPath) -> MovieContentItem
}

protocol MovieViewModelAction {
    func sort(by sortType: MovieListRequest.SortType)
    func loadFirstPage()
    func loadNextPage()
}

protocol MovieViewModelType {
    var delegate: MovieViewModelDelegate? { get set }
    var datasource: MovieViewModelDatasource { get }
    var action: MovieViewModelAction { get }
}

protocol MovieViewModelDelegate: AnyObject {
    func movieViewModelDidReloadData(_ viewModel: MovieViewModelType)
}

final class MovieViewModel: MovieViewModelType {
    
    weak var delegate: MovieViewModelDelegate?
    
    private var controller: MovieController = MovieController()
    private var items: [MovieContentItem] = []
    
    var datasource: MovieViewModelDatasource {
        return self
    }
    
    var action: MovieViewModelAction {
        return self
    }
    
    init() {
        controller.delegate = self
    }
    
    private func updateDataSource(model: [MovieModel]) {
        var newDatasourceItems: [MovieContentItem] = []
                
        let media = getMovieAttributes(models: model)
        if media.canAddMedia {
            newDatasourceItems += media.items
        }
        
        if (!controller.isLoading) {
            newDatasourceItems += [.loading]
        }
        
        items = newDatasourceItems
        DispatchQueue.main.async {
            self.delegate?.movieViewModelDidReloadData(self)
        }
    }
    
    private func getMovieAttributes(models: [MovieModel]) -> (canAddMedia: Bool, items: [MovieContentItem]){
        guard !models.isEmpty else { return (false, []) }
        var items: [MovieContentItem] = []
        items.append(.movie(models))
        return (true, items)
    }

}

// MARK: MovieViewModelAction
extension MovieViewModel: MovieViewModelAction {
    
    func sort(by sortType: MovieListRequest.SortType) {
        controller.sortType = sortType
    }
    
    func loadFirstPage() {
        controller.loadData(withPage: 1)
    }
    
    func loadNextPage() {
        controller.page += 1
    }
    
}

// MARK: MovieViewModelDatasource
extension MovieViewModel: MovieViewModelDatasource {
    
    var currentSortType: MovieListRequest.SortType {
        return controller.sortType
    }
    
    var numberOfSections: Int {
        return items.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        switch items[section] {
        case .loading:
            return 1
        case .movie(let models):
            return models.count
        }
    }
    
    func itemAt(_ indexPath: IndexPath) -> MovieContentItem {
        return items[indexPath.section]
    }
    
    func section(at indexPath: IndexPath) -> MovieContentItem {
        return items[indexPath.section]
    }
    
}

extension MovieViewModel: MovieControllerDelegate {
    
    func movieController(_ controller: MovieController, withModel model: [MovieModel]) {
        updateDataSource(model: model)
    }
    
}
