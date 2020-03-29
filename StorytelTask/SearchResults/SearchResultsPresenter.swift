//
//  SearchResultsPresenter.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import Foundation

/**
 Presenter protocol to represent events/requests received from the UI
 */
protocol ViewPresenterProtocol: class {
    var view: SearchResultsViewProtocol? { get set }
    var interactor: SearchResultsInteractorProtocol? { get set }
    var router: SearchResultsRouterProtocol? { get set }
    
    var query: String? { get set }
    var books: [BookItem] { get set }
    
    /**
     View has loaded, so get some data
     */
    func viewDidLoad()
    
    /**
     Get the next page of results
     */
    func fetchNextPage()
    
    /**
     Get the number of rows of data
     - returns:
        - Int: The number of rows
     */
    func numberOfRowsInSection() -> Int
    
    /**
     Get the data for the cell specified at indexPath
     - parameters:
        - indexPAth: The index path of the cell
     - returns:
        - A SearchResultCellModel representing the cell data.
     */
    func cellData(indexPath: IndexPath) -> SearchResultCellModel
}

/**
 Presenter protocol to represent events sent from the Interactor
 */
protocol SearchResultsPresenterProtocol: class {
    func searchResultSuccess(query: String?, results: [BookItem]?)
    func searchResultFailure(errorCode: SearchResultError)
    func imageCacheUpdated()
}

class SearchResultsPresenter: ViewPresenterProtocol {
    
    func fetchNextPage() {
        if interactor?.hasNextPage ?? false {
            interactor?.loadNextPage()
        }
        else {
            DispatchQueue.main.async {
                self.view?.isLastPage()
            }
            
        }
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
    
    func cellData(indexPath: IndexPath) -> SearchResultCellModel {
        let coverData = cover(indexPath: indexPath)
        let bookTitle = books[indexPath.row].title
        let authors = books[indexPath.row].authors.map { $0.name }
        let narrators = books[indexPath.row].narrators.map { $0.name }
        
        return SearchResultCellModel(cover: coverData, title: bookTitle, authors: authors, narrators: narrators)
    }
    
    private func cover(indexPath: IndexPath) -> Data? {
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
    
    func searchResultFailure(errorCode: SearchResultError) {
        DispatchQueue.main.async {
            self.view?.getQueryFailure(error: errorCode.rawValue)
        }
    }
    
}
