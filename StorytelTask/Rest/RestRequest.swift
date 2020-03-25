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


protocol RestRequest {
    associatedtype ResponseType: Decodable
    
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
    
    func decode(data: Data) -> ResponseType? {
        return try? JSONDecoder().decode(ResponseType.self, from: data)
    }
    
}
