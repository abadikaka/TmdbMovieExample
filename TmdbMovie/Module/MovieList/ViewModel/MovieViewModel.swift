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
    
    private let controller: MovieController = MovieController()
    private var items: [MovieContentItem] = []
    
    var datasource: MovieViewModelDatasource {
        return self
    }
    
    var action: MovieViewModelAction {
        return self
    }
    
    private func updateDataSource() {
        var newDatasourceItems: [MovieContentItem] = []
        
        if (!controller.isLoading) {
            newDatasourceItems += [.loading]
        }
        
        let media = mediaAttributes
        if media.canAddMedia {
            newDatasourceItems += media.items
        }
        
        items = newDatasourceItems
        delegate?.movieViewModelDidReloadData(self)
    }
    
    private var mediaAttributes: (canAddMedia: Bool, items: [MovieContentItem]) {
        guard !controller.models.isEmpty else { return (false, []) }
        var items: [MovieContentItem] = []
        items.append(.movie(controller.models))
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
