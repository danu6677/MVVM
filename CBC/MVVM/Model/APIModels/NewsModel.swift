//
//  NewsModel.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation

struct NewsModel:Codable {
    let id: Int?
    let title: String?
    let description: String?
    let source: String?
    let publishedAt: Int?
    let type: String?
    let images:ImageURL?
    let imageData:Data?
}

struct ImageURL:Codable {
    let square_140: String?
}
