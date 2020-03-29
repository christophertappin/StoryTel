//
//  SearchResultsRouter.swift
//  StorytelTask
//
//  Created by ChrisTappin on 26/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import UIKit

/**
 Handles routing for the SearchResults module
 */
protocol SearchResultsRouterProtocol {
    /**
     Create the viewController
     */
    static func create() -> UINavigationController
}

class SearchResultsRouter: SearchResultsRouterProtocol {
    static func create() -> UINavigationController {
        let viewController = SearchResultsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let presenter = SearchResultsPresenter()
        presenter.router = SearchResultsRouter()
        presenter.view = viewController
        
        let interactor = SearchResultsInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        viewController.presenter = presenter
        
        return navigationController
    }
}
