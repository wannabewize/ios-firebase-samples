//
//  Model.swift
//  Model
//
//  Created by MRF on 2021/08/14.
//

import Foundation


struct MovieData: Codable {
    var data: [MovieInfo]
}

struct MovieInfo: Codable {
    var title: String
    var director: String
    var actors: String
    var poster: String
}


