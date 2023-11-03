//
//  CBCTests.swift
//  CBCTests
//
//  Created by Danutha Fernando on 2023-09-30.
//

import XCTest
@testable import CBC

final class CBCTests: XCTestCase {
    
    var viewModel: NewsViewModel!
    var mockNewsService: MockNewsService!
    var testCoreDataStack: TestCoreDataStack!
    
    override func setUp() {
        mockNewsService = MockNewsService()
        testCoreDataStack = TestCoreDataStack(type: .fileURL)
        viewModel = .init(coreDataStack: testCoreDataStack,newsService: mockNewsService)
        
    }
    
    //Test if the data returned is not nil
    func testIfNewsReturned()  {
        viewModel.fetchNews(completion: { (result) in
            switch result {
            case .success():
                //Total news count is not nill in mockFilmService
                XCTAssertNotNil(self.viewModel.newsData.count)
            case .failure(let error):
                XCTAssertFalse(error.localizedDescription == AlertMerssage.UNKNOWN_ERROR_MESSAGE)
            }
        })
    }
    
    //Test if the next page increment works properly for pagination/infinite scroll
    func testNextPageOnReload() {
        let currentPage = 1
        viewModel.fetchNews(completion: { (result) in
            switch result {
            case .success():
                //Total Film count is 4 in mockFilmService
                for _ in 1...currentPage {
                    self.viewModel.setPageOffset()
                }
                XCTAssertTrue( NewsViewModel.PAGE_SETTINGS.nextPage > currentPage)
                
            case .failure(let error):
                XCTAssertFalse(error.localizedDescription == AlertMerssage.UNKNOWN_ERROR_MESSAGE)
            }
        })
        
    }
    
    func testFetchNewsFromAPIOnReload() {
        viewModel.fetchNews(completion: { (result) in
            switch result {
            case .success():
                //Total News count is 4 in mockFilmService
                XCTAssertEqual(self.viewModel.newsData.count,4)
                
            case .failure(let error):
                XCTAssertFalse(error.localizedDescription == AlertMerssage.UNKNOWN_ERROR_MESSAGE)
            }
        })
    }
}
