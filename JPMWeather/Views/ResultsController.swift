//
//  ResultsController.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/23/23.
//

import UIKit

//ResultsViewController used for the Searchbar results.
//Given more time the error handling could've been much better here,
//but for now it just displays an empty list given no results
class ResultsController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .systemCyan
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    }
    
    var callBack: ((String, String) -> ())?
    var viewModel = ResultsViewModel()
    
    func updateTableView(results: [GeoLocation]){
        viewModel.results = results
        self.tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.textProperties.color = .white
        config.text = viewModel.formatCellText(for: indexPath.row)
        cell.contentConfiguration = config
        cell.backgroundColor = .systemCyan
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = viewModel.results[indexPath.row]
        callBack?(String(selection.lat), String(selection.lon))
    }
}


