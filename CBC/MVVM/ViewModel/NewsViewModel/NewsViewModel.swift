//
//  NewsViewModel.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
import CoreData

final class NewsViewModel {
    
    private (set) var newsData = [NewsModel]()//Original Data
    private (set) var filteredNewsData = [NewsModel]()//Accessed by the VC
    private (set) var uniqueNewsTypes = Set<String> ()//Filter Options on UI
    private (set) static var PAGE_SETTINGS = (nextPage:1, pageSize: 10, offset: 0)
    private let newsDataService:NewsServiceProtocol
    private let _coreDataStack:CoreDataStackProtocol
    
    //MARK: Dependency Injection
    init(coreDataStack:CoreDataStackProtocol = CoreDataStack(),
         newsService:NewsServiceProtocol = NewsDataService()) {
        newsDataService = newsService
        _coreDataStack = coreDataStack
    }
    //Fetch data based on the app state
    public func fetchNews(completion:@escaping (Result<Void, Error>)-> Void,_ isReload:Bool = false) {
        //MARK: If data is not available on coredata, fetch from the API, else use the core data for processing
        if isReload {
            //If the CollectionView had reloaded, needs to fetch data from the API
            fetchFromAPIAndSaveData(completion: completion)
        }else {
            fetchFromCoreDataThenAPI(completion: completion)
        }
    }
    
    //SaveData parameter is to draw the line between unit test and actual data. Bcz in unit test it's not needed to save the mock data in the DB
    fileprivate func fetchFromAPIAndSaveData(completion: @escaping (Result<Void, Error>) -> Void) {
        
        newsDataService.fetchNewsData(nextPage:  NewsViewModel.PAGE_SETTINGS.nextPage, pageSize:  NewsViewModel.PAGE_SETTINGS.pageSize, offset:  NewsViewModel.PAGE_SETTINGS.offset, success: { [weak self] (apiData) in
            guard let self = self else { return }
            
            if let news = apiData {
                self.newsData = news
                // Save to CoreData
                CoreDataManager(coreDataStack: _coreDataStack).saveAndUpdateNews(data: news)
                self.fetchFromCoreDataThenAPI(completion: completion)
                
            } else {
                // Handle the case where result is [] from the API.
                let error = NSError(domain: Constants.API, code: -1, userInfo: [NSLocalizedDescriptionKey: AlertMerssage.SERVER_ERROR_MESSAGE])
                completion(.failure(error))
            }
        }) { (error_code, message) in
            let error = NSError(domain: Constants.API, code: error_code, userInfo: [NSLocalizedDescriptionKey: "\(message)"])
            completion(.failure(error))
        }
    }
    
    
    //Fetch the Data from DB and if empty fetch from the API
    private func fetchFromCoreDataThenAPI(completion: @escaping (Result<Void, Error>) -> Void) {
        do{
            try CoreDataManager(coreDataStack: _coreDataStack).fetchData(entity: Entity.NEWS, model: News.self, completion: {[weak self](result: [NSManagedObject]?) in
                
                guard let self = self else { return }
                guard let finalResults = result as? [News] else {return}
                
                if finalResults.isEmpty {
                    fetchFromAPIAndSaveData(completion: completion)
                }else{
                    let data = finalResults.map({news in
                        NewsModel(id: Int(news.news_id),
                                  title: news.title,
                                  description: news.news_description,
                                  source: news.source,
                                  publishedAt: Int(news.publishedAt),
                                  type: news.news_type,
                                  images: nil,
                                  imageData: news.image_data)
                    })
                    
                    self.newsData = data
                    self.filteredNewsData = self.newsData
                    self.uniqueNewsTypes = Set(self.newsData.map { $0.type ?? ""})
                    self.uniqueNewsTypes.insert(Constants.ALL)
                    completion(.success(()))
                }
            })
            
        }catch{
            let error = NSError(domain: AlertMerssage.CORE_DATA_ERROR, code: -1, userInfo: [NSLocalizedDescriptionKey: "\(AlertMerssage.CORE_DATA_ERROR)"])
            completion(.failure(error))
        }
    }
    
    //Filter Data based on the type selected
    func filterData(with type: String)  {
        self.filteredNewsData = type == Constants.ALL ? self.newsData : self.newsData.filter { $0.type == type}
    }
    
    //Pagination Logic to fetch data from the API
    func setPageOffset () {
        let retrievedValue = UserDefaults.standard.integer(forKey:Constants.NEXT_PAGE)
        if retrievedValue < NewsViewModel.PAGE_SETTINGS.nextPage {
            NewsViewModel.PAGE_SETTINGS.nextPage += 1
            UserDefaults.standard.set(NewsViewModel.PAGE_SETTINGS.nextPage, forKey: Constants.NEXT_PAGE)
            UserDefaults.standard.synchronize()
        }else{
            NewsViewModel.PAGE_SETTINGS.nextPage = retrievedValue
        }
        NewsViewModel.PAGE_SETTINGS.offset = newsData.count
    }
    
}
