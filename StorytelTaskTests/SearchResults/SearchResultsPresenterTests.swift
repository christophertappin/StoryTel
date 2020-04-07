//
//  SearchResultsPresenterTests.swift
//  StorytelTaskTests
//
//  Created by ChrisTappin on 27/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import StorytelTask

class SearchResultsPresenterTests: XCTestCase {
    
    class InteractorMock: SearchResultsInteractorProtocol {
        var hasNextPage: Bool = false

        var presenter: SearchResultsPresenterProtocol?
        
        var images: [String: Data] = [:]
        
        func loadResults(page: String?) {
            
        }
        
        func loadNextPage() {
            
        }
        
        func loadImage(url: URL) -> Data? {
            return images[url.absoluteString]
        }
        
        
    }
    
    var interactorMock = InteractorMock()

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
    
    func testFetchNextPageSuccess() {
        let searchResultsPresenter = SearchResultsPresenter()
        
        searchResultsPresenter.books = [
            BookItem(title: "firstBook", authors: [], narrators: [], cover: nil),
            BookItem(title: "secondBook", authors: [], narrators: [], cover: nil)]
        
        searchResultsPresenter.searchResultSuccess(query: "query", results: [BookItem(title: "thirdBook", authors: [], narrators: [], cover: nil)])
        
        XCTAssertEqual(searchResultsPresenter.books.count, 3)
    }
    
    func testBookTitleForIndexPath() {
        let searchResultsPresenter = SearchResultsPresenter()
        
        searchResultsPresenter.books = [
            BookItem(title: "firstBook", authors: [], narrators: [], cover: nil),
            BookItem(title: "secondBook", authors: [], narrators: [], cover: nil)]
        
        XCTAssertEqual(searchResultsPresenter.cellData(indexPath: IndexPath(row: 1, section: 0)).title, searchResultsPresenter.books[1].title)
    }
    
    func testCoverForIndexPath() {
        let searchResultsPresenter = SearchResultsPresenter()
        searchResultsPresenter.interactor = interactorMock
        
        let url1 = "http://url.one"
        let url2 = "http://url.two"
        let cover1 = String("data1").data(using: .utf8)!
        let cover2 = String("data2").data(using: .utf8)!
        
        interactorMock.images = [url1: cover1, url2: cover2]
        
        searchResultsPresenter.books = [
            BookItem(title: "firstBook", authors: [], narrators: [], cover: Cover(url: url1, width: 10, height: 10)),
            BookItem(title: "secondBook", authors: [], narrators: [], cover: Cover(url: url2, width: 10, height: 10))]
        
        XCTAssertEqual(searchResultsPresenter.cellData(indexPath: IndexPath(row: 1, section: 0)).cover, cover2)
    }
    
    func testNumberOfRowsInSection() {
        let searchResultsPresenter = SearchResultsPresenter()
        
        searchResultsPresenter.books = [
            BookItem(title: "firstBook", authors: [], narrators: [], cover: nil),
            BookItem(title: "secondBook", authors: [], narrators: [], cover: nil)]
        
        XCTAssertEqual(searchResultsPresenter.numberOfRowsInSection(), 2)
    }
    
    func testAuthorsForIndexPath() {
        let searchResultsPresenter = SearchResultsPresenter()
        
        searchResultsPresenter.books = [
            BookItem(title: "firstBook", authors: [Author(id: "id1", name: "name1")], narrators: [], cover: nil),
            BookItem(title: "secondBook", authors: [], narrators: [], cover: nil)]
        
        let authors = searchResultsPresenter.cellData(indexPath: IndexPath(row: 0, section:0)).authors
        
        XCTAssertEqual(authors.count, 1)
        XCTAssertEqual(authors, ["name1"])
    }
    
    func testNarratorsForIndexPath() {
        let searchResultsPresenter = SearchResultsPresenter()
        
        searchResultsPresenter.books = [
            BookItem(title: "firstBook", authors: [], narrators: [], cover: nil),
            BookItem(title: "secondBook", authors: [], narrators: [Narrator(id: "id1", name: "narrator")], cover: nil)]
        
        let narrators = searchResultsPresenter.cellData(indexPath: IndexPath(row: 1, section: 0)).narrators
        
        XCTAssertEqual(narrators.count, 1)
        XCTAssertEqual(narrators, ["narrator"])
    }

}
