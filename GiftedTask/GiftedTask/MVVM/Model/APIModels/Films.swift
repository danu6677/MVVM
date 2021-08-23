//
//  Films.swift
//  GiftedTask
//
//  Created by zone on 8/17/21.
//

import Foundation

struct AllFilms:Codable {
    var results: [Movie]?
}

struct Movie:Codable {
    var episode_id: Int?
    var title :String?
    var opening_crawl:String?
    var director :String?
    var producer :String?
    var release_date :String?
    var characters :[String]?
}


struct APIData {
    var network_image:Data?
    var film:Movie?
    var characters: [APICharacter]?
}
