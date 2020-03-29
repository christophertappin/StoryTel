//
//  RestRequest.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

enum StorytelAPI {
    static let scheme = "https"
    static let host = "api.storytel.net"
}

/**
 An HTTP request
 */
protocol Request {
    associatedtype ResponseType: Decodable
    
    var url: URL { get }
    
    func response(data: Data) -> ResponseType?
}

/**
 A REST request
 */
protocol RestRequest: Request {
    
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    
}

extension RestRequest {
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = StorytelAPI.scheme
        urlComponents.host = StorytelAPI.host
        urlComponents.path = "/" + path
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
    
    func response(data: Data) -> ResponseType? {
        return try? JSONDecoder().decode(ResponseType.self, from: data)
    }
    
}
