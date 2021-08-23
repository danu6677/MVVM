//
//  Protocols.swift
//  GiftedTask
//
//  Created by zone on 8/21/21.
//

import Foundation

protocol FilmServiceProtocol {
    func fetchFilmData(success:@escaping ([APIData]?)->Void,failure:@escaping (Int,String)->Void)
}
