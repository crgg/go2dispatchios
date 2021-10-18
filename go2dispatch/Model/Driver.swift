//
//  Driver.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 8/25/21.
//

import Foundation
struct Driver : Codable {
    var name : String
    var driver_id : String
    var latitude : Double
    var longitude : Double
}

struct Resultados : Codable {
    var results : [Game]
}

struct Game: Codable, Hashable {
    let title, studio, contentRaiting, publicationYear: String
    let gameDescription: String
    let platforms, tags: [String]
    let videosUrls: VideosUrls
    let galleryImages: [String]

    enum CodingKeys: String, CodingKey {
        case title, studio, contentRaiting, publicationYear
        case gameDescription = "description"
        case platforms, tags, videosUrls, galleryImages
    }
}

// MARK: - VideosUrls
struct VideosUrls: Codable, Hashable {
    let mobile, tablet: String
}

typealias Games = [Game]
