//
//  SearchRequestTests.swift
//  StorytelTaskTests
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import StorytelTask

class SearchRequestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConstructorWithPage() {
        let request = SearchRequest(query: "harry", page: "PageToken")
        
        XCTAssertEqual(request.queryItems.count, 2)
        XCTAssertTrue(request.queryItems.contains(where: {
            $0.name == "query"
        }))
        XCTAssertTrue(request.queryItems.contains(where: {
            $0.name == "page"
        }))
        XCTAssertEqual(request.queryItems.first(where: { $0.name == "query" })?.value, "harry")
        XCTAssertEqual(request.queryItems.first(where: { $0.name == "page" })?.value, "PageToken")
    }
    
    func testConstructorWithoutPage() {
        let request = SearchRequest(query: "harry", page: nil)
        
        XCTAssertEqual(request.queryItems.count, 1)
        XCTAssertTrue(request.queryItems.contains(where: {
            $0.name == "query"
        }))
        XCTAssertFalse(request.queryItems.contains(where: {
            $0.name == "page"
        }))
        XCTAssertEqual(request.queryItems.first(where: { $0.name == "query" })?.value, "harry")
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
