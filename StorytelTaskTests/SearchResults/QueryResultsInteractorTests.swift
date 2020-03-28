//
//  QueryResultsInteractorTests.swift
//  StorytelTaskTests
//
//  Created by ChrisTappin on 28/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import StorytelTask

class QueryResultsInteractorTests: XCTestCase {
    
    var restControllerMock: RestControllerMock!
    var searchApiService: SearchApiService!
    var imageRequestService: ImageRequestService!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restControllerMock = RestControllerMock()
        searchApiService = SearchApiService(restController: restControllerMock)
        imageRequestService = ImageRequestService(restController: restControllerMock)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadResults() {
        let searchResult = SearchResult(query: "query",
                                        totalCount: 10,
                                        items: [BookItem(title: "title", authors: [], narrators: [], cover: nil)])
        let result: Result<Decodable?, RestError> = .success(searchResult)
        restControllerMock.result = result
        let searchResultsInteractor = SearchResultsInteractor(searchApiService: searchApiService,
                                                              imageRequestService: imageRequestService)
        
        searchResultsInteractor.loadResults()
        XCTAssertEqual(searchResultsInteractor.searchResults, searchResult)
    }
    
    func testLoadResultsFailure() {
        let result: Result<Decodable?, RestError> = .failure(.badRequest)
        restControllerMock.result = result
        
        let searchResultsInteractor = SearchResultsInteractor(searchApiService: searchApiService,
                                                              imageRequestService: imageRequestService)
        
        searchResultsInteractor.loadResults()
        XCTAssertEqual(searchResultsInteractor.searchResults, nil)
    }
    
    func testLoadNextPage() {
        let searchResult = SearchResult(query: "query",
                                        totalCount: 10,
                                        items: [BookItem(title: "title", authors: [], narrators: [], cover: nil)])
        let result: Result<Decodable?, RestError> = .success(searchResult)
        restControllerMock.result = result
        let searchResultsInteractor = SearchResultsInteractor(searchApiService: searchApiService,
                                                              imageRequestService: imageRequestService)
        // Set the original query results
        let originalResult = SearchResult(query: "query", nextPageToken: "nextPageToken", totalCount: 10, items: [])
        searchResultsInteractor.searchResults = originalResult
        
        searchResultsInteractor.loadNextPage()
        
        XCTAssertNotEqual(searchResultsInteractor.searchResults, originalResult)
        XCTAssertEqual(searchResultsInteractor.searchResults, searchResult)
        
    }
    
    func testLoadNextPageWhenNoFurtherPagesExist() {
        let searchResult = SearchResult(query: "query",
                                        totalCount: 10,
                                        items: [BookItem(title: "title", authors: [], narrators: [], cover: nil)])
        
        let searchResultsInteractor = SearchResultsInteractor(searchApiService: searchApiService,
                                                              imageRequestService: imageRequestService)
        searchResultsInteractor.searchResults = searchResult
        
        // Check to result doesn't change
        XCTAssertEqual(searchResultsInteractor.searchResults, searchResult)
        searchResultsInteractor.loadNextPage()
        XCTAssertEqual(searchResultsInteractor.searchResults, searchResult)
    }

}
