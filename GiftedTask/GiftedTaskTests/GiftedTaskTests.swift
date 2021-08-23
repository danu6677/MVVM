//
//  GiftedTaskTests.swift
//  GiftedTaskTests
//
//  Created by zone on 8/16/21.
//

import XCTest
@testable import GiftedTask

/****Unit Test******/
class GiftedTaskTests: XCTestCase {
    
    var viewModel: FilmsViewModel!
    var mockFilmService: MockFilmService!
    
    override func setUp() {
        //Dependecy injection
        mockFilmService = MockFilmService()
        viewModel = .init(moviesService: mockFilmService)
    }

    //Test if the Film count is 4 (same as the mock model)
    func testTotalFilmsReturned()  {
        viewModel.fetchFilms(false, completion: { (result) in
            switch result {
                case .success():
                    //Total Film count is 4 in mockFilmService
                    XCTAssertTrue(self.viewModel.apiData.count == 4)
                    
                case .failure(let error):
                    XCTAssertFalse(error.localizedDescription == Constants.UNKNOWN_ERROR_MESSAGE)
            }
        }, true)
    }
    
    //Test if the total character count is 8 (same as the mock model)
    func testTotalCharctersReturned() {
        viewModel.fetchFilms (false,completion:{ (result) in
            switch result {
                case .success():
                    //Total count of Characters should be 8 in mockFilmService once the data is retrieved
                    let totalCharacters = self.viewModel.apiData.map{$0.characters?.count ?? 0}.reduce(0,+)
                    XCTAssertTrue(totalCharacters == 8)
                    
                case .failure(let error):
                    XCTAssertFalse(error.localizedDescription == Constants.UNKNOWN_ERROR_MESSAGE)
            }
        },true)
    }
    
    //Test if the characters are empty
    func testCharactersOfEachMovies() {
        viewModel.fetchFilms (false,completion:{ (result) in
            switch result {
                case .success():
                    //Total count of Characters should be 8 in mockFilmService once the data is retrieved
                    let totalCharacters = self.viewModel.apiData.map{$0.characters?.count ?? 0}.reduce(0,+)
                    XCTAssertFalse(totalCharacters == 0)
                    
                case .failure(let error):
                    XCTAssertFalse(error.localizedDescription == Constants.UNKNOWN_ERROR_MESSAGE)
            }
        },true)
    }
    
    //Test if the Episode Ids are empty
    func testIdOfEachMovies() {
        viewModel.fetchFilms (false,completion:{ (result) in
            switch result {
                case .success():
                    //Total count of Characters should be 8 in mockFilmService once the data is retrieved
                    let episodeId = self.viewModel.apiData.map{$0.film?.episode_id}.last!
                    XCTAssertTrue(episodeId != nil)
                    
                case .failure(let error):
                    XCTAssertFalse(error.localizedDescription == Constants.UNKNOWN_ERROR_MESSAGE)
                }
        },true)
    }
}
