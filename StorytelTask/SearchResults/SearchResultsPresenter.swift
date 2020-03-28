//
//  SearchResultsPresenter.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

protocol ViewPresenterProtocol: class {
    var view: SearchResultsViewProtocol? { get set }
    var interactor: SearchResultsInteractorProtocol? { get set }
    var router: SearchResultsRouterProtocol? { get set }
    
    var query: String? { get set }
    var books: [BookItem] { get set }
    
    func viewDidLoad()
    func fetchNextPage()
    func numberOfRowsInSection() -> Int
    func bookTitle(indexPath: IndexPath) -> String
    func authors(indexPath: IndexPath) -> [String]
    func narrators(indexPath: IndexPath) -> [String]
    func cover(indexPath: IndexPath) -> Data?
}

protocol SearchResultsPresenterProtocol: class {
    func searchResultSuccess(query: String?, results: [BookItem]?)
    func searchResultFailure(errorCode: Int)
    func imageCacheUpdated()
}

class SearchResultsPresenter: ViewPresenterProtocol {
    func fetchNextPage() {
        interactor?.loadNextPage()
    }
    
    
    var view: SearchResultsViewProtocol?
    var interactor: SearchResultsInteractorProtocol?
    var router: SearchResultsRouterProtocol?
    
    var query: String?
    var books: [BookItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.getQuerySuccess()
            }
        }
    }
    var imageCache = NSCache <NSString, NSData>()
    
    func viewDidLoad() {
        interactor?.loadResults(page: nil)
    }
    
    func numberOfRowsInSection() -> Int {
        return books.count
    }
    
    func bookTitle(indexPath: IndexPath) -> String {
        return books[indexPath.row].title
    }
    
    func authors(indexPath: IndexPath) -> [String] {
//        if let authors = books[indexPath.row].authors {
//            return authors.map { $0.name }
//        }
//        
//        return nil
        
        return books[indexPath.row].authors.map { $0.name }
    }
    
    func narrators(indexPath: IndexPath) -> [String] {
//        if let narrators = books[indexPath.row].narrators {
//            return narrators.map { $0.name }
//        }
//
//        return nil
        
        return books[indexPath.row].narrators.map { $0.name }
    }
    
    func cover(indexPath: IndexPath) -> Data? {
        var data: Data?
        if let urlString = books[indexPath.row].cover?.url,
            let url = URL(string: urlString) {
            data = interactor?.loadImage(url: url)
        }
        
        return data
    }
    
    
}

extension SearchResultsPresenter: SearchResultsPresenterProtocol {
    func imageCacheUpdated() {
        DispatchQueue.main.async {
            self.view?.getImageSuccess()
        }
    }
    
    func searchResultSuccess(query: String?, results: [BookItem]?) {
        self.query = query
        if let results =  results {
            self.books.append(contentsOf: results)
        }
        
    }
    
    func searchResultFailure(errorCode: Int) {
        view?.getQueryFailure(error: "An error occured fetching results")
    }
    
    

    
    
}
