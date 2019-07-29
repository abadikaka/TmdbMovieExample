//
//  MovieListRequest.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 23/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation

class MovieListRequest: BaseRequest {
    
    enum SortType {
        case popularity
        case rating
        
        var additionalParams: String {
            switch self {
            case .popularity:
                return "popularity.desc"
            case .rating:
                return "vote_count.desc"
            }
        }
    }
    
    var endpoint: String {
        return "\(TmdbConfig.baseUrl)/3/discover/movie?api_key=\(TmdbConfig.apiKey_v3)&language=en-US&sort_by=\(sortBy.additionalParams)&page=\(pages)"
    }
    
    var params: ParametersDict? = nil
    var header: HeadersDict? = nil
    var pages: Int = 1
    
    private var sortBy: SortType = .popularity
    
    init(sortBy: SortType, pages: Int) {
        self.sortBy = sortBy
        self.pages = pages
    }
}
