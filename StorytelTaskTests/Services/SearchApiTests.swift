//
//  SearchApiTests.swift
//  StorytelTaskTests
//
//  Created by ChrisTappin on 26/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import StorytelTask

class RestControllerMock: RestControllerProtocol {
    var result: Result<Decodable?, RestError>?
    
    func send<T: Request>(_ request: T, completionHandler completion: @escaping (Result<T.ResponseType, RestError>) -> Void) {
        
        switch result {
        case .failure(let error):
            completion(.failure(error))
        case .success(let searchResult as T.ResponseType):
            completion(.success(searchResult))
        case .none:
            break
        case .some(_):
            break
        }
    }
    
}

class SearchApiTests: XCTestCase {
    
    var restUrlSessionMock: RestURLSessionMock!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restUrlSessionMock = RestURLSessionMock()
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
    
    func testGetResultsFailure() {
        let result: Result<Decodable?, RestError> = .failure(.badRequest)
        
        let restControllerMock = RestControllerMock()
        restControllerMock.result = result
        
        let searchApiService = SearchApiService(restController: restControllerMock)
        
        var searchResult: Result<SearchResult, SearchError>?
        
        searchApiService.getResults(query: "query", page: "A Non existent page reference", completion: { result in
            searchResult = result
        })
        
        XCTAssertEqual(searchResult, Result<SearchResult, SearchError>.failure(.genericError))
    }
    
    func testGetResultsSuccess() {
        let searchResult = SearchResult(query: "query", totalCount: 10, items: [])
        let result: Result<Decodable?, RestError> = .success(searchResult)
        
        let restControllerMock = RestControllerMock()
        restControllerMock.result = result
        
        let searchApiService = SearchApiService(restController: restControllerMock)
        
        var apiResult: Result<SearchResult, SearchError>?
        
        searchApiService.getResults(query: "query", page: nil, completion: { result in
            apiResult = result
        })
        
        XCTAssertEqual(apiResult, Result<SearchResult, SearchError>.success(searchResult))
    }

}
