//
//  RestApiService.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

enum SearchError: Error {
    case genericError
}

class SearchApiService {
    
    var restController: RestControllerProtocol
    
    init(restController: RestControllerProtocol = RestController()) {
        self.restController = restController
    }
    
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
