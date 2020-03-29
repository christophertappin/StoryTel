//
//  SearchResultsInteractor.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

/**
 Interator for SearchResults. Fetched Data and sends to the presenter.
 */
protocol SearchResultsInteractorProtocol {
    var presenter: SearchResultsPresenterProtocol? { get set }
    
    var hasNextPage: Bool { get }
    
    /**
     Loads query results
     - parameters:
        - page: Optional page token
     */
    func loadResults(page: String?)
    
    /**
     Loads the next page, if one exists
     */
    func loadNextPage()
    
    /**
     Loads an image from the specified url
     - parameters:
        - url: The URL of the image to load
     */
    func loadImage(url: URL) -> Data?
}

/**
 Represents an error retrieving search results
 */
enum SearchResultError: String, Error {
    typealias RawValue = String
    
    // TODO: Implement more specific errors.
    case genericError = "An error occured fetching search results"
}

class SearchResultsInteractor: SearchResultsInteractorProtocol {
    
    var searchApiService: SearchApiService
    var imageRequestService: ImageRequestService
    weak var presenter: SearchResultsPresenterProtocol?
    
    var hasNextPage: Bool {
        return searchResults?.nextPageToken != nil
    }
    
    var searchResults: SearchResult? {
        didSet {
            self.presenter?.searchResultSuccess(query: searchResults?.query, results: searchResults?.items)
        }
    }
    
    var imageCache = NSCache<NSString, NSData>()
    
    init(searchApiService: SearchApiService = SearchApiService(),
         imageRequestService: ImageRequestService = ImageRequestService()) {
        self.searchApiService = searchApiService
        self.imageRequestService = imageRequestService
    }

    
    func loadResults(page: String? = nil) {
        
        searchApiService.getResults(query: "harry", page: page, completion: { [weak self] result in
            switch result {
            case .failure(_):
                self?.presenter?.searchResultFailure(errorCode: .genericError)
            case .success(let response):
                self?.searchResults = response
                
            }
        })
        
    }
    
    func loadNextPage() {
        // TODO: Make sure we're not fetching the same results twice
        if let nextPage = searchResults?.nextPageToken {
            loadResults(page: nextPage)
        }
    }
    
    func loadImage(url: URL) -> Data? {
        if let image = imageCache.object(forKey: url.absoluteString as NSString) {
            return image as Data
        }
        imageRequestService.getResults(url: url, completion: { [weak self] result in
            switch result {
            case .failure(_):
                // If we can't get the image, just carry on
                break
            case .success(let response):
                self?.imageCache.setObject(response as NSData, forKey: url.absoluteString as NSString)
                self?.presenter?.imageCacheUpdated()
            }
        })
        
        return nil
    }
    
}
