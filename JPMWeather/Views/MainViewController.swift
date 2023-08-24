//
//  ViewController.swift
//  JPMWeather
//
//  Created by Takhti, Gholamreza on 8/20/23.
//

import UIKit
import Combine
import CoreLocation

//home page VC that holds the views. The UI is relatively simple as I focused more on architecture and
//following best practices. Holds the view model that has most of the logic.
class MainViewController: UIViewController {
    lazy var searchBar : UISearchController = {
        let resultsVC = ResultsController()
        resultsVC.callBack = self.getWeather
        let search = UISearchController(searchResultsController: resultsVC)
        search.searchResultsUpdater = self
        search.searchBar.tintColor = UIColor.systemGray6
        search.obscuresBackgroundDuringPresentation = true
        search.searchBar.placeholder = "Search for a city"
        return search
    }()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let locationLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.preferredFont(forTextStyle: .title3)
        return l
    }()
    
    let tempLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return l
    }()
    let conditionLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.preferredFont(forTextStyle: .body)
        return l
    }()
    let highLowLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.preferredFont(forTextStyle: .body)
        return l
    }()
    
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let viewModel = MainViewModel()
    var cancellabes = Set<AnyCancellable>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.setupObservers()
        self.requestLocation()
    }
    
    private func setupObservers(){
        //using a simple publisher from Combine.
        //This is my favorite way of handling bindings in MVVM, and given more time
        //would've used Combine significantly more.
        viewModel.$image.sink { [weak self] image in
            self?.imageView.image = image
        }.store(in: &cancellabes)
    }
    
    private func setupViews(){
        //very generic UI work. I prefer a programmtic UI as opposed to using storyboard,
        //so there's some extra code here.
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for a city", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.view.backgroundColor = .systemCyan
        self.navigationItem.searchController = self.searchBar
        self.view.addSubview(stackView)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = appearance
        self.title = "Weather"
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(conditionLabel)
        stackView.addArrangedSubview(highLowLabel)
        stackView.addArrangedSubview(imageView)
        imageView.setConstraints(height: 75)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func getWeather(lat: String, lon: String) {
        searchBar.dismiss(animated: true)
        showActivityIndicator()
        viewModel.makeWeatherRequest(lat: lat, long: lon) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.hideActivityIndicator()
                self.locationLabel.text = response.name
                self.tempLabel.text = String(Int(response.main.temp)) + "°"
                self.conditionLabel.text = response.weather.first?.main
                self.highLowLabel.text = self.viewModel.formatHighLowLabel(response: response)
                if let id = response.weather.first?.icon {
                    self.viewModel.loadImage(id: id)
                }
            case .failure(_):
                //There definitely needs to be better error handling here.
                //I am very limited on time, and like I've mentioned previously
                //I deprioritized UI and focused more on architecture.
                //There should definitely be better handling in a production ready app.
                break
            }
        }
    }
    
    private func showActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.stackView.isHidden = true
    }
    
    private func hideActivityIndicator() {
        self.activityIndicator.isHidden = true
        self.stackView.isHidden = false
    }
    
    let locationManager = CLLocationManager()
    private func requestLocation() {
        //doing very basic location work here.
        //would've definitely modularized this and put it in it's own class
        //given more time.
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
        
    }
    
}

extension MainViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        showActivityIndicator()
        viewModel.makeCoordinatesCall(with: searchController.searchBar.text!) { result in
            self.hideActivityIndicator()
            guard let vc = searchController.searchResultsController as? ResultsController else {
                return
            }
            switch result {
            case .success(let results):
                vc.updateTableView(results: results)
            case .failure(_):
                //again, definitely need better error handling
                break
            }
        }
    }
}

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //one thing I wasn't sure of is if the user has both location services on,
        //and previously searched weather location saved in userdefaults, which one
        //should I use? I decided to go with the userdefaults data, as that seemed to make more
        //sense from a product perspective.
        if let location = locations.first {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            if UserDefaults.standard.object(forKey: "geolat") == nil,
               UserDefaults.standard.object(forKey: "geolon") == nil {
                getWeather(lat: latitude, lon: longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //again, definitely need better error handling
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
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

