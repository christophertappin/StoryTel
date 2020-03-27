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
}

class SearchResultsViewController: UIViewController {
    
    var presenter: ViewPresenterProtocol?
    
    var header: String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .systemGroupedBackground
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "queryResultCell")
        
        let headerView = tableViewHeader
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.tableHeaderView = headerView
        
        headerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200.0).isActive = true
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        tableView.layoutIfNeeded()
        
        return tableView
    }()
    
    lazy var tableViewHeader: UILabel = {
        let headerView = UILabel()
        headerView.text = header
        headerView.font = .systemFont(ofSize: 36)
        headerView.textAlignment = .center
        headerView.backgroundColor = .systemGroupedBackground
        
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        // Show spinner while we fetch initial results
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
}

// MARK: - Setup view
extension SearchResultsViewController {
//    func setupView() {
//        setupTableView()
//        setupTableViewConstraints()
//
//
//
//
//
//        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "queryResultCell")
//
//        let headerView = UILabel()
//        headerView.text = header
//        headerView.font = .systemFont(ofSize: 36)
//        headerView.textAlignment = .center
//        headerView.backgroundColor = .systemGroupedBackground
//        headerView.layer.opacity = 0.85
//        headerView.isOpaque = false
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        let headerLabel = UILabel()
//        headerLabel.text = header
//        headerView.addSubview(headerLabel)
//        tableView.tableHeaderView = headerView
//        headerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
//        headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200.0).isActive = true
//        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
//        headerView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
//        tableView.layoutIfNeeded()
//    }
//
//    func setupTableViewHeader() {
//
//    }
//
//    func setupTableView() {
//        view.addSubview(tableView)
//        tableView.backgroundColor = .systemGroupedBackground
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
//    }
//
//    func setupTableViewConstraints() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
}

// MARK: - Table view data source
extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queryResultCell", for: indexPath) as! SearchResultTableViewCell
        cell.titleLabel.text = presenter?.bookTitle(indexPath: indexPath)
        if let authors = presenter?.authors(indexPath: indexPath),
            authors.count > 0 {
            
            cell.authorsLabel.text = "By: " + authors.joined(separator: ", ")
        }
        if let narrators = presenter?.narrators(indexPath: indexPath),
            narrators.count > 0 {
            
            cell.narratorsLabel.text = "With: " + narrators.joined(separator: ", ")
        }
        
        if let data = presenter?.cover(indexPath: indexPath) {
            cell.cover.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return presenter?.query
//    }
}

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let totalRows = presenter?.numberOfRowsInSection(),
            indexPath.row == totalRows - 1 {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            presenter?.fetchNextPage()
        }
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchResultsViewController: SearchResultsViewProtocol {
    func getImageSuccess() {
        self.tableView.reloadData()
    }
    
    func getQuerySuccess() {
        self.tableView.reloadData()
        let header = tableView.tableHeaderView as? UILabel
        header?.text = "Query: " + (presenter?.query ?? "")
    }
    
    func getQueryFailure(error: String) {
//        self.tableView.reloadData()
    }
    
    
}
