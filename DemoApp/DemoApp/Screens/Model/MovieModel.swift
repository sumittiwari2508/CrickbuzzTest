//
//  FlickerModel.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 17/10/24.
//

import Foundation

struct ParentItem {
    let title: String
    var isExpanded: Bool
    let childItems: [String]
}

struct Movie: Codable {
    let title: String
    let year: String
    let released: String
    let genre: String
    let director: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let poster: String
    let ratings: [Rating]
    let imdbRating: String

    
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case poster = "Poster"
        case ratings = "Ratings"
        case imdbRating = "imdbRating"
       
    }
}

struct Rating: Codable {
    let source: String
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
