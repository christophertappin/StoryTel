//
//  SearchRequest.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

struct SearchRequest: RestRequest {
    var path: String = "search"
    
    var queryItems: [URLQueryItem]
    
    typealias ResponseType = SearchResult
    
    init(query: String, page: String? = nil) {
        
        let queryQueryItem = URLQueryItem(name: "query", value: query)
        queryItems = [queryQueryItem]
        
        if let page = page {
            let pageQueryItem = URLQueryItem(name: "page", value: page)
            queryItems.append(pageQueryItem)
        }
    }
}

struct ImageRequest: RestRequest {
    var path: String
    
    var queryItems: [URLQueryItem]
    
    typealias ResponseType = Data
    
    var url: URL
    
    init(url: URL, path: String = "", queryItems: [URLQueryItem] = []) {
        self.url = url
        self.path = path
        self.queryItems = queryItems
    }
    
    func decode(data: Data) -> Data? {
        return data
    }
}

struct SearchResult: Decodable {
    var query: String
    var items: [BookItem]
}

extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.query == rhs.query && lhs.items == rhs.items
    }
}

typealias Author = Person
typealias Narrator = Person

struct BookItem: Decodable {
    var title: String?
    var authors: [Author]?
    var narrators: [Narrator]?
    var cover: Cover?
}

extension BookItem: Equatable {
    static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        lhs.title == rhs.title
            && lhs.authors == rhs.authors
            && lhs.narrators == rhs.narrators
            && lhs.cover == rhs.cover
    }
}

struct Person: Decodable {
    var id: String
    var name: String
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
    }
}

struct Cover: Decodable {
    var url: String
    var width: Int
    var height: Int
}

extension Cover: Equatable {
    static func == (lhs: Cover, rhs: Cover) -> Bool {
        lhs.url == rhs.url
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }
}

