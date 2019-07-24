//
//  MovieModel.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation


struct MovieModel {
    let thumbnail: URL?
    let title: String
    let synopsis: String
    let rating: Int
    let releaseDate: String
    let isFavorite: Bool
}
