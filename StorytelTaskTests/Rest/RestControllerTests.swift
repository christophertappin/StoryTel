//
//  RestControllerTests.swift
//  StorytelTaskTests
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import StorytelTask

class RestURLSessionMock: RestURLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func restTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }
    
}

class RestControllerTests: XCTestCase {
    
    func testSuccessResponse() {
        let restUrlSessionMock = RestURLSessionMock()
        restUrlSessionMock.data = """
        {
            "query": "harry",
            "filter": "books",
            "nextPageToken": "OS40ODI4MzZ%2bfjExNTk4OH5%2bMTA%3d",
            "totalCount": 1554,
            "items": [
                {
                    "id": "14871",
                    "title": "Harry",
                    "originalTitle": "",
                    "type": "single",
                    "authors": [
                        {
                            "id": "7766",
                            "name": "Tim Wohlforth"
                        }
                    ],
                    "narrators": [
                        {
                            "id": "1026",
                            "name": "Joe Barrett"
                        }
                    ],
                    "cover": {
                        "url": "https://www.storytel.se/images/9781482956436/640x640/cover.jpg",
                        "width": 640,
                        "height": 640
                    },
                    "tags": [],
                    "seriesId": null,
                    "seriesName": null,
                    "orderInSeries": null,
                    "seasonNumber": null,
                    "resultType": "book"
                }
            ]
        }
        """.data(using: .utf8)
        
        // Create a success response
        let response = HTTPURLResponse(url: URL(string: "https://https://www.storytel.se")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        restUrlSessionMock.response = response
        
        let searchResult = SearchResult(query: "harry",
                                        totalCount: 10,
                                        items: [BookItem(title: "Harry",
                                                         authors: [Author(id: "7766",
                                                                          name: "Tim Wohlforth")],
                                                         narrators: [Narrator(id: "1026",
                                                                              name: "Joe Barrett")],
                                                         cover: Cover(url: "https://www.storytel.se/images/9781482956436/640x640/cover.jpg", width: 640, height: 640) )])
        
        var restResult: Result<SearchRequest.ResponseType, RestError>?
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry"), completionHandler: { result in
            
            restResult = result
        })
        
        XCTAssertEqual(restResult, Result<SearchRequest.ResponseType, RestError>.success(searchResult))
        
    }
    
    func testFailureResponseBadRequest() {
        let restUrlSessionMock = RestURLSessionMock()
        
        let response = HTTPURLResponse(url: URL(string: "https://https://www.storytel.se")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        restUrlSessionMock.response = response
        
        var restResult: Result<SearchRequest.ResponseType, RestError>?
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry")) { result in
            restResult = result
        }
        
        XCTAssertEqual(restResult, Result<SearchRequest.ResponseType, RestError>.failure(.badRequest))
    }
    
    func testFailureResponseNotFound() {
        let restUrlSessionMock = RestURLSessionMock()
        
        let response = HTTPURLResponse(url: URL(string: "https://https://www.storytel.se")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        restUrlSessionMock.response = response
        
        var restResult: Result<SearchRequest.ResponseType, RestError>?
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry")) { result in
            restResult = result
        }
        
        XCTAssertEqual(restResult, Result<SearchRequest.ResponseType, RestError>.failure(.notFound))
    }

    func testFailureResponseOther() {
        let restUrlSessionMock = RestURLSessionMock()
        
        let response = HTTPURLResponse(url: URL(string: "https://https://www.storytel.se")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        restUrlSessionMock.response = response
        
        var restResult: Result<SearchRequest.ResponseType, RestError>?
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry")) { result in
            restResult = result
        }
        
        XCTAssertEqual(restResult, Result<SearchRequest.ResponseType, RestError>.failure(.unknownError))
    }
    
    func testError() {
        let restUrlSessionMock = RestURLSessionMock()
        restUrlSessionMock.error = NSError()
        
        var restResult: Result<SearchRequest.ResponseType, RestError>?
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry")) { result in
            restResult = result
        }
        
        XCTAssertEqual(restResult, Result<SearchRequest.ResponseType, RestError>.failure(.unknownError))
    }
    
    func testIncorrectDataType() {
        let restUrlSessionMock = RestURLSessionMock()
        restUrlSessionMock.data = """
        {
            "an": "invalid",
            "json": "response"
        }
        """.data(using: .utf8)
        
        // Create a success response
        let response = HTTPURLResponse(url: URL(string: "https://https://www.storytel.se")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        restUrlSessionMock.response = response
        
        var restResult: Result<SearchRequest.ResponseType, RestError>?
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry"), completionHandler: { result in
            
            restResult = result
        })
        
        XCTAssertEqual(restResult, Result<SearchRequest.ResponseType, RestError>.failure(.decodeError))
    }

}
