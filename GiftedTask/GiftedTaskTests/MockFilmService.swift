//
//  MockFilmService.swift
//  GiftedTaskTests
//
//  Created by zone on 8/21/21.
//

import Foundation

class MockFilmService: FilmServiceProtocol {
    
    func fetchFilmData(success: @escaping ([APIData]?) -> Void, failure: @escaping (Int, String) -> Void) {
        var mockData = [APIData] ()
        for i in 1...4 {
           let film = Movie(episode_id: i, title: "Movie\(i)", opening_crawl: "Open \(i)", director: "Director \(i)", producer: "Producer \(i)", release_date: "November \(i)st", characters: ["\(i+1)","\(i+2)"])
            let character = [APICharacter(name: "John \(i)", birth_year: "199\(i)", gender: i%2 == 0 ? "Male" : "Female"),APICharacter(name: "Paul \(i)", birth_year: "198\(i)", gender: i%2 == 0 ? "Female" : "Male")]
            
           let data = APIData(film: film, characters: character)
            mockData.append(data)
        }
        success(mockData)
    }
    
}
