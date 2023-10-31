//
//  NewsServiceProtocol.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation


protocol NewsServiceProtocol {
    func fetchNewsData(nextPage:Int, pageSize: Int, offset:Int,success:@escaping ([NewsModel]?)->Void,failure:@escaping (Int,String)->Void)
}
