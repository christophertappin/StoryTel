//
//  ImageRequestServiceTests.swift
//  StorytelTaskTests
//
//  Created by ChrisTappin on 27/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import StorytelTask

class ImageRequestServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

        let imageRequestService = ImageRequestService(restController: restControllerMock)

        var imageResult: Result<Data, ImageError>?

        imageRequestService.getResults(url: URL(string: "http://a.fake.url/")!, completion: { result in
            imageResult = result
        })

        XCTAssertEqual(imageResult, Result<Data, ImageError>.failure(.imageError))
    }
    
    func testGetResultsSuccess() {
        let resultData = Data()
        let result: Result<Decodable?, RestError> = .success(resultData)
        
        let restControllerMock = RestControllerMock()
        restControllerMock.result = result
        
        let imageRequestService = ImageRequestService(restController: restControllerMock)
        
        var apiResult: Result<Data, ImageError>?
        
        imageRequestService.getResults(url: URL(string: "http://a.fake.url/")!, completion: { result in
            apiResult = result
        })
        
        XCTAssertEqual(apiResult, Result<Data, ImageError>.success(resultData))
    }

}
