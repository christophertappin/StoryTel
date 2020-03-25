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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
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
                                        items: [BookItem(title: "Harry",
                                                         authors: [Author(id: "7766",
                                                                          name: "Tim Wohlforth")],
                                                         narrators: [Narrator(id: "1026",
                                                                              name: "Joe Barrett")],
                                                         cover: Cover(url: "https://www.storytel.se/images/9781482956436/640x640/cover.jpg", width: 640, height: 640) )])
        
        let restController = RestController(session: restUrlSessionMock)
        restController.send(SearchRequest(query: "harry"), completionHandler: { result in
            
            XCTAssertEqual(result, Result<SearchRequest.ResponseType, RestError>.success(searchResult))
        })
        
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

}
