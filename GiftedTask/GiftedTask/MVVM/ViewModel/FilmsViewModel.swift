//
//  FilmsViewModel.swift
//  GiftedTask
//
//  Created by zone on 8/19/21.
//

import Foundation

class FilmsViewModel {
    
    //Instance variables 
    private (set) var films = [Film]()
    private (set) var apiData = [APIData]()//Uinit Testing purpose

    private let filmDataService:FilmServiceProtocol
    
    //Dependency Injection
    init(moviesService:FilmServiceProtocol = FilmDataService()) {
        filmDataService = moviesService
    }
    
    
    public func fetchFilms(_ save: Bool? = true,completion:@escaping (Result<Void, Error>)-> Void,_ network_changed:Bool = false) {
       
        if !network_changed {
            do{
                try CoreDataManager.shared.fetchData(entity: "Film", model: Film.self, completion: {[weak self] (result) in
                    if result.count > 0 {
                        self?.films = result
                        completion(.success(()))
                    }else{
                        self?.getDataFromAPI(saveData: save!, completion: completion)
                    }
                })
            }catch{
                print("CoreData Error")
            }
        }else {
            self.getDataFromAPI(saveData: save!, completion: completion)
        }
       
    }
    
    fileprivate func getDataFromAPI(saveData:Bool,completion:@escaping (Result<Void, Error>)-> Void) {
        
        filmDataService.fetchFilmData {[weak self] (result) in
            if let films = result{
                self?.apiData = films
               //Save to CoreData
                if saveData{
                    CoreDataManager.shared.dropTables()
                    CoreDataManager.shared.saveAndUpdateFilms(data: films)
                    self?.getFimlsFromCoreData()
                }
            }
          
            completion(.success(()))
        } failure: { (error_code,message) in
            print(error_code)
            let error = NSError(domain: "API Call", code: error_code, userInfo: [ NSLocalizedDescriptionKey: "\(message)"])
            
            completion(.failure(error))
        }
    }
    
    fileprivate func getFimlsFromCoreData() {
        do{
            try CoreDataManager.shared.fetchData(entity: ENTITIES.FILM.rawValue, model: Film.self, completion: {[weak self] (result) in
                let films = result
                self?.films = films
                
            })
        }catch{
            print("CoreData Retrieving Error")
           
        }
    }
}
