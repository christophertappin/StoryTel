//
//  SearchResultsTableViewController.swift
//  StorytelTask
//
//  Created by ChrisTappin on 25/03/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import UIKit

protocol SearchResultsViewProtocol {
    func getQuerySuccess()
    func getQueryFailure(error: String)
    func getImageSuccess()
    func isLastPage()
}

/**
 View controller to show the results of the search query
 */
class SearchResultsViewController: UIViewController {
    
    var presenter: ViewPresenterProtocol?
    
    var header: String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 90

        tableView.tableHeaderView = tableViewHeader
        
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "queryResultCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var tableViewHeader: UILabel = {
        let headerView = UILabel()
        headerView.text = header
        headerView.font = .systemFont(ofSize: 36)
        headerView.textAlignment = .center
        headerView.backgroundColor = .systemGroupedBackground
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        // Show spinner while we fetch initial results
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        tableView.backgroundView = spinner
        tableView.tableFooterView?.isHidden = false
    }
}

// MARK: - Setup view
extension SearchResultsViewController {
    func layoutView() {
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.tableHeaderView?.topAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.tableHeaderView?.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            tableView.tableHeaderView?.heightAnchor.constraint(greaterThanOrEqualToConstant: 200.0)
        ]
        NSLayoutConstraint.activate(constraints as! [NSLayoutConstraint])
    }
}

// MARK: - Table view data source
extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as! SearchResultTableViewCell
        cell.cellModel = presenter?.cellData(indexPath: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
}

// MARK: - Table view delegate methods
extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let totalRows = presenter?.numberOfRowsInSection(),
            indexPath.row == totalRows - 1 {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            presenter?.fetchNextPage()
            
            // TODO: Hide the spinner if this is the last page
        }
    }

}

// MARK: - Respond to events from the presenter
extension SearchResultsViewController: SearchResultsViewProtocol {
    func getImageSuccess() {
        tableView.reloadData()
    }
    
    func getQuerySuccess() {
        tableView.reloadData()
        let header = tableView.tableHeaderView as? UILabel
        header?.text = "Query: " + (presenter?.query ?? "")
    }
    
    func getQueryFailure(error: String) {
        let alert = UIAlertController(title: "An error occured", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        tableView.tableFooterView?.isHidden = true
    }
    
    func isLastPage() {
        // Hide the spinner as there's no more data
        tableView.tableFooterView?.isHidden = true
    }
}
