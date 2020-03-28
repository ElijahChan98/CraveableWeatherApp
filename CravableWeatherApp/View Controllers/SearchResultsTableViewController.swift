//
//  SearchResultsTableViewController.swift
//  CravableWeatherApp
//
//  Created by Elijah Tristan Huey Chan on 26/03/2020.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    private let useLocation: [String] = [Constants.USE_CURRENT_LOCATION]
    var searchHistoryResults: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var searchResults: [String] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var data: [[String]] {
        get {
            return [useLocation, searchHistoryResults, searchResults]
        }
    }
    
    weak var delegate: SearchResultsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.accessibilityIdentifier = "myUniqueTableViewIdentifier"
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Location Service"
        case 1:
            return "Previous Searches"
        case 2:
            return "Search Results"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
        let cellText = data[indexPath.section][indexPath.row]

        cell.textLabel?.text = cellText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = data[indexPath.section][indexPath.row]
        self.delegate?.handleRowSelection?(result: selectedResult)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedResult = searchHistoryResults[indexPath.row]
            self.delegate?.handleRowDeletion?(deletedResult: deletedResult)
            self.searchHistoryResults.remove(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1:
            return true
        default:
            return false
        }
    }

}

@objc protocol SearchResultsTableViewControllerDelegate {
    @objc optional func handleRowSelection(result: String)
    @objc optional func handleRowDeletion(deletedResult: String)
}
