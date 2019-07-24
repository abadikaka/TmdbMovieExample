//
//  Movie.swift
//  TmdbMovie
//
//  Created by Michael Abadi on 24/07/19.
//  Copyright © 2019 Michael Abadi Santoso. All rights reserved.
//

import Foundation

class Movie {
    let posterPath: String?
    let adult: Bool?
    let overview: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let id: Int?
    let originalTitle: String?
    let originalLanguage: String?
    let title: String?
    let backdropPath: String?
    let popularity: NSNumber?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: NSNumber?
    
    
    init(posterPath: String?,
         adult: Bool?,
         overview: String?,
         releaseDate: String?,
         genreIds: [Int]?,
         id: Int?,
         originalTitle: String?,
         originalLanguage: String?,
         title: String?,
         backdropPath: String?,
         popularity: NSNumber?,
         voteCount: Int?,
         video: Bool?,
         voteAverage: NSNumber?) {
        self.posterPath = posterPath
        self.adult = adult
        self.overview = overview
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.id = id
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.title = title
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteCount = voteCount
        self.video = video
        self.voteAverage = voteAverage
    }
    
    
}
