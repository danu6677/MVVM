//
//  Config.swift
//  GiftedTask
//
//  Created by zone on 8/16/21.
//

class Config {
    private static var VERSION_NUMBER = "" // MARK: - routing to the relavant end-points handled from the back-end
    static let BASE_URL = "https://swapi.dev/api/"
    
    
    public static let getFilms = BASE_URL + VERSION_NUMBER + "/films/"
    public static let getCharacter = BASE_URL + VERSION_NUMBER + "/people/"
    
    
}
