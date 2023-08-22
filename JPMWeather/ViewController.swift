//
//  ViewController.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import UIKit

class ResultsController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    }
    var callBack: ((GeoLocation) -> ())?
    var results: [GeoLocation] = []
    
    func updateTableView(results: [GeoLocation]){
        self.results = results
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = results[indexPath.row].name + ", " + results[indexPath.row].state + ", " + results[indexPath.row].country
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callBack?(results[indexPath.row])
    }
}

class ViewController: UIViewController {
    var callBack: ((GeoLocation) -> ())?
    
    lazy var searchBar : UISearchController = {
        let resultsVC = ResultsController()
        resultsVC.callBack = self.callback
        let search = UISearchController(searchResultsController: resultsVC)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search for a city"
        return search
    }()
    
    let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        self.view.backgroundColor = .systemBackground
        self.navigationItem.searchController = self.searchBar
    }
    
    private func callback(_ location: GeoLocation) {
        searchBar.dismiss(animated: true)
        viewModel.makeWeatherRequest(lat: String(location.lat), long: String(location.lon))
    }


}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.makeCoordinatesCall(with: searchController.searchBar.text!) { result in
            switch result {
            case .success(let success):
                if let vc = searchController.searchResultsController as? ResultsController {
                    vc.updateTableView(results: success)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    
}

class MainViewModel {
    
    let coordinatesService: CoordinatesService
    let weatherService: WeatherService
    private var callWorkItem: DispatchWorkItem?
    
    init(coordinatesService: CoordinatesService = CoordinatesService(),
         weatherService: WeatherService = WeatherService()){
        self.coordinatesService = coordinatesService
        self.weatherService = WeatherService()
    }
    
    func makeCoordinatesCall(with input: String, completion: @escaping (Result<[GeoLocation], APIError>) -> Void){
        guard !input.isEmpty else { return }
        callWorkItem?.cancel()
        
        callWorkItem = DispatchWorkItem(block: {
            self.coordinatesService.urlProvider.input = input
            self.coordinatesService.makeRequest(with: completion)
            self.coordinatesService.makeRequest { result in
                switch result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
        })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: callWorkItem!)
    }
    
    func makeWeatherRequest(lat: String, long: String) {
        weatherService.urlProvider.lat = lat
        weatherService.urlProvider.lon = long
        weatherService.makeRequest { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
                    


extension UIView {
    func setConstraints(top: NSLayoutYAxisAnchor? = nil, topPadding: CGFloat = 0,
                        bottom: NSLayoutYAxisAnchor? = nil, bottomPadding: CGFloat = 0,
                        leading: NSLayoutXAxisAnchor? = nil, leadingPadding: CGFloat = 0,
                        trailing: NSLayoutXAxisAnchor? = nil, trailingPadding: CGFloat = 0,
                        width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -trailingPadding).isActive = true
        }
        
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: leadingPadding).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
