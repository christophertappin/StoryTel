//
//  RestApiService.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

/**
 Search result error type
 */
enum SearchError: Error {
    case genericError
}

/**
 Service for handling REST requests
 */
class SearchApiService {
    
    var restController: RestControllerProtocol
    
    init(restController: RestControllerProtocol = RestController()) {
        self.restController = restController
    }
    
    /**
     Gets results based on the query provided
     
     - parameters:
        - query: The Search query
        - page: The page reference, if any
        - completion: The completion handler
     */
    func getResults(query: String, page: String? = nil, completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        
        let searchRequest = SearchRequest(query: query, page: page)
        self.restController.send(searchRequest, completionHandler: { result in
            switch result {
            case .failure(_):
                completion(.failure(.genericError))
            case .success(let response):
                completion(.success(response))
            }
        })
    }
}
