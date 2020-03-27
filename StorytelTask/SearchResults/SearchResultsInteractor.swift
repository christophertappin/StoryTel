//
//  SearchResultsInteractor.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

protocol SearchResultsInteractorProtocol {
    var presenter: SearchResultsPresenterProtocol? { get set }
    
    func loadResults(page: String?)
    func loadNextPage()
    func loadImage(url: URL) -> Data?
    func result(forIndex index: Int)
}

class SearchResultsInteractor: SearchResultsInteractorProtocol {
    
    var searchApiService: SearchApiService
    var imageRequestService: ImageRequestService
    weak var presenter: SearchResultsPresenterProtocol?
    
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
                break // Display some error
            case .success(let response):
                self?.searchResults = response
                
            }
        })
        
    }
    
    func loadNextPage() {
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
            case .failure(let error):
                break
            case .success(let response):
                self?.imageCache.setObject(response as NSData, forKey: url.absoluteString as NSString)
                self?.presenter?.imageCacheUpdated()
            }
        })
        
        return nil
    }
    
    func result(forIndex index: Int) {
        
    }
    
    
}
