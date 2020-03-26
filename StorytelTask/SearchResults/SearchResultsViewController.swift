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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }
}

// MARK: - Setup view
extension SearchResultsViewController {
    func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constrain tableview to the view's margins...
        let margins = view.layoutMarginsGuide
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "queryResultCell")
        
    }
}

// MARK: - Table view data source
extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "queryResultCell", for: indexPath) as! SearchResultTableViewCell
        cell.titleLabel.text = presenter?.bookTitle(indexPath: indexPath)
        cell.authorsLabel.text = presenter?.authors(indexPath: indexPath)?.joined(separator: ", ")
        cell.narratorsLabel.text = presenter?.narrators(indexPath: indexPath)?.joined(separator: ", ")
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
}

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    }
    
    func getQueryFailure(error: String) {
//        self.tableView.reloadData()
    }
    
    
}
