//
//  NewsDataService.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation

/****All the network requests related task will be proccessed here****/
final class NewsDataService: NewsServiceProtocol {
    
    func fetchNewsData(nextPage:Int, pageSize: Int, offset:Int, success: @escaping ([NewsModel]?) -> Void, failure: @escaping (Int, String) -> Void) {
        Network.shared.getNewsFeed(nextPage:nextPage, pageSize: pageSize, offset:offset,successBlock: {(result) in
            if let newsData = result as? [NewsModel]{
                success(newsData)
            }
        }) { (error_code,errorDetail,header) in
            failure(error_code,errorDetail)
        }
    }
}

