//
//  FilmaDataRepository.swift
//  GiftedTask
//
//  Created by zone on 8/20/21.
//

import Foundation

/****All the API data will be proccessed here****/
final class FilmDataService: FilmServiceProtocol {
    
    var totalCharacterCount = 0 //Total count of characters of all movies
    var networkCount = 0 //How many times the Network call executes
    var tempCollection = [APIData]()
    var finalApiDataCollection = [APIData]()
    var allMovies = [Movie]()
    var network_image :Data?
    
    func fetchFilmData(success: @escaping ([APIData]?) -> Void, failure: @escaping (Int,String) -> Void) {
        //self.view.showLoader()
        
        clearReferences()
        Utils.loadImage(url: Constants.STATIC_IMAGE_URL) {[weak self] (result)in self?.network_image = result}

        //Get all films
        Network.shared.getFilms(successBlock: {(result) in
            if let filmData = result as? AllFilms, let movies = filmData.results {
                
                self.allMovies = movies
                self.totalCharacterCount = self.allMovies.map{$0.characters!.count}.sum()
               
                //Get Characters for every movie with the character Id
                for (movie) in movies {
                    if let charcters = movie.characters {
                        for (character) in charcters {
                            let characterId = (character.split {!($0.isNumber)}.map{String($0)}).last
                            self.getCharacters(id: characterId!, movie: movie,success,failure)
                           
                        }
                    }
                }
            }
        }) { (error_code,errorDetail,header) in
            failure(error_code,errorDetail)
            print(errorDetail.description)
        }
    }
    
    //Get the Character Details for the film
    fileprivate func getCharacters(id:String,movie:Movie,_ success: @escaping ([APIData]?) -> Void,_ failure: @escaping (Int,String) -> Void){
        
        Network.shared.getCharacters(characterId: id, successBlock: {[weak self](result) in

            if let data = result as? APICharacter {
                self?.networkCount += 1
                self?.tempCollection.append(APIData(film: movie,
                                                    characters: [data]))
                
                if (self?.networkCount != 0) && (self?.networkCount == self?.totalCharacterCount){
                    
                  //Bind to a single Struct conforms to the protocol
                    guard let movies = self?.allMovies else {return}
                    for movie in movies {
                        let data = self?.tempCollection.filter {$0.film?.episode_id == movie.episode_id}.map{$0.characters![0]}
                        let model = APIData(
                            network_image: self?.network_image,
                            film: movie,
                            characters: data
                        )
                        self?.finalApiDataCollection.append(model)
                    }
                    print("Done...............................................")
                    success(self?.finalApiDataCollection)
                }
            }
            
        }) { (error_code,errorDetail,header) in
            /*Some times when the load to too much to handle the https client it throws a 404. In at that instance its better to re-try the network call with a slight delay*/
            if error_code == 404 {
                do {
                    Utils.delay(bySeconds: 2, dispatchLevel: .main) {
                        self.getCharacters(id: id, movie: movie,success,failure)
                    }
                }
            }else{
                failure(error_code,errorDetail)
            }
        }
     }
    
    fileprivate func clearReferences() {
        totalCharacterCount = 0
        networkCount = 0
        tempCollection = []
        finalApiDataCollection = []
    }
  }

