//
//  MovieModel.swift
//  Flixster
//
//  Created on 11/04/23.
//

import Foundation

struct mainData:Decodable {
    let results: [movieData]
}

struct movieData:Decodable {
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
    let popularity: Double
    let vote_average: Double
    let vote_count: Int
}
