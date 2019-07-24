//
//  MovieViewModel.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation

protocol MovieViewModelDatasource {
    
}

protocol MovieViewModelAction {
    
}

protocol MovieViewModelType {
    var delegate: MovieViewModelDelegate? { get set }
    var datasource: MovieViewModelDatasource { get }
    var action: MovieViewModelAction { get }
}

protocol MovieViewModelDelegate: AnyObject {
    
}

final class MovieViewModel: MovieViewModelType {
    
    weak var delegate: MovieViewModelDelegate?
    
    var datasource: MovieViewModelDatasource {
        return self
    }
    
    var action: MovieViewModelAction {
        return self
    }

}

extension MovieViewModel: MovieViewModelAction {
    
}

extension MovieViewModel: MovieViewModelDatasource {
    
}
