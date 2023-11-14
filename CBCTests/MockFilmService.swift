//
//  MockFilmService.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
class MockNewsService: NewsServiceProtocol {
    func fetchNewsData(nextPage: Int, pageSize: Int, offset: Int, success: @escaping ([NewsModel]?) -> Void, failure: @escaping (Int, String) -> Void) {
        var mockData = [NewsModel] ()
        for i in 1...4 {
            let news = NewsModel(id: 76543456+i, publishedAt: 1695645673573, title: "Some Title:\(i)", description: "Some discryption", source: "Somesource", type: "Some type:\(i)", images: ImageURL(square_140: "https://i.cbc.ca/1.6987746.1697246245!/fileImage/httpImage/image.JPG_gen/derivatives/16x9tight_140/trudeau-housing-20231005.JPG"),imageData: nil)
            mockData.append(news)
        }
        success(mockData)
    }
    
}
